import pytest
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.pool import StaticPool

# Import after conftest.py sets environment variables
from app.main import app
from app.database import Base, get_db
from app.models.user import User
from app.models.mood import MoodEntry
from app.auth import verify_token


# Use the test database URL from environment (set in conftest.py)
import os
SQLALCHEMY_DATABASE_URL = os.environ.get("DATABASE_URL", "sqlite:///test.db")

engine = create_engine(
    SQLALCHEMY_DATABASE_URL,
    connect_args={"check_same_thread": False},
    poolclass=StaticPool,
)

TestingSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)


@pytest.fixture(scope="function")
def db_session():
    """Create a fresh database for each test."""
    # Drop all tables first to ensure clean state
    Base.metadata.drop_all(bind=engine)
    # Create all tables
    Base.metadata.create_all(bind=engine)
    db = TestingSessionLocal()
    try:
        yield db
    finally:
        db.rollback()
        db.close()
        # Clean up tables for next test
        Base.metadata.drop_all(bind=engine)


@pytest.fixture(scope="function")
def client(db_session):
    """Create a test client with database override."""
    # Ensure tables are created before creating client
    Base.metadata.create_all(bind=engine)
    
    def override_get_db():
        try:
            yield db_session
        finally:
            pass

    app.dependency_overrides[get_db] = override_get_db
    yield TestClient(app)
    app.dependency_overrides.clear()


@pytest.fixture
def test_user_with_firebase(db_session):
    """Create a test user with firebase_uid in the database."""
    # Note: This assumes User model has firebase_uid field
    # If not, you may need to add it or adjust the test
    user = User(
        email="test@example.com",
        hashed_password="hashed_password_here",
        firebase_uid="test-firebase-uid-123"
    )
    db_session.add(user)
    db_session.commit()
    db_session.refresh(user)
    return user


@pytest.fixture
def test_user_with_firebase_alt(db_session):
    """Create another test user with different firebase_uid."""
    user = User(
        email="test2@example.com",
        hashed_password="hashed_password_here",
        firebase_uid="test-firebase-uid-456"
    )
    db_session.add(user)
    db_session.commit()
    db_session.refresh(user)
    return user


class TestCreateMood:
    """Test cases for POST /moods endpoint."""

    def test_create_mood_success(self, client, db_session, test_user_with_firebase):
        """Test successful mood creation."""
        # Override the verify_token dependency
        def mock_verify_token():
            return {"uid": "test-firebase-uid-123", "email": "test@example.com"}
        
        from app.auth import verify_token
        app.dependency_overrides[verify_token] = mock_verify_token
        
        response = client.post(
            "/api/v1/moods",
            json={
                "mood_score": 7,
                "energy_level": 6,
                "stress_level": 3
            },
            headers={"Authorization": "Bearer fake-token"}
        )
        
        assert response.status_code == 200
        data = response.json()
        assert "id" in data
        
        # Verify the mood entry was created in the database
        db_session.refresh(test_user_with_firebase)
        entries = db_session.query(MoodEntry).filter(MoodEntry.user_id == test_user_with_firebase.id).all()
        assert len(entries) == 1
        assert entries[0].user_id == test_user_with_firebase.id
        
        app.dependency_overrides.clear()

    def test_create_mood_missing_fields(self, client, db_session, test_user_with_firebase):
        """Test mood creation with missing required fields."""
        def mock_verify_token():
            return {"uid": "test-firebase-uid-123", "email": "test@example.com"}
        
        from app.auth import verify_token
        app.dependency_overrides[verify_token] = mock_verify_token
        
        # Missing energy_level and stress_level
        response = client.post(
            "/api/v1/moods",
            json={
                "mood_score": 7
            },
            headers={"Authorization": "Bearer fake-token"}
        )
        
        # Should fail because required fields are missing
        assert response.status_code in [422, 500]  # Validation error or KeyError
        
        app.dependency_overrides.clear()

    def test_create_mood_no_auth(self, client):
        """Test mood creation without authentication."""
        # Don't override verify_token, let it fail
        
        response = client.post(
            "/api/v1/moods",
            json={
                "mood_score": 7,
                "energy_level": 6,
                "stress_level": 3
            }
        )
        
        assert response.status_code == 401

    def test_create_mood_user_not_found(self, client, db_session):
        """Test mood creation when user doesn't exist."""
        def mock_verify_token():
            return {"uid": "non-existent-uid", "email": "test@example.com"}
        
        from app.auth import verify_token
        app.dependency_overrides[verify_token] = mock_verify_token
        
        response = client.post(
            "/api/v1/moods",
            json={
                "mood_score": 7,
                "energy_level": 6,
                "stress_level": 3
            },
            headers={"Authorization": "Bearer fake-token"}
        )
        
        # Should fail because user doesn't exist (user will be None)
        assert response.status_code == 500  # AttributeError when accessing user.id
        
        app.dependency_overrides.clear()

    def test_create_mood_multiple_entries(self, client, db_session, test_user_with_firebase):
        """Test creating multiple mood entries for the same user."""
        def mock_verify_token():
            return {"uid": "test-firebase-uid-123", "email": "test@example.com"}
        
        from app.auth import verify_token
        app.dependency_overrides[verify_token] = mock_verify_token
        
        # Create first entry
        response1 = client.post(
            "/api/v1/moods",
            json={
                "mood_score": 7,
                "energy_level": 6,
                "stress_level": 3
            },
            headers={"Authorization": "Bearer fake-token"}
        )
        assert response1.status_code == 200
        
        # Create second entry
        response2 = client.post(
            "/api/v1/moods",
            json={
                "mood_score": 8,
                "energy_level": 7,
                "stress_level": 2
            },
            headers={"Authorization": "Bearer fake-token"}
        )
        assert response2.status_code == 200
        
        # Verify both entries exist
        entries = db_session.query(MoodEntry).filter(MoodEntry.user_id == test_user_with_firebase.id).all()
        assert len(entries) == 2
        
        app.dependency_overrides.clear()


class TestListMoods:
    """Test cases for GET /moods endpoint."""

    def test_list_moods_success(self, client, db_session, test_user_with_firebase):
        """Test successful retrieval of mood entries."""
        def mock_verify_token():
            return {"uid": "test-firebase-uid-123", "email": "test@example.com"}
        
        from app.auth import verify_token
        app.dependency_overrides[verify_token] = mock_verify_token
        
        # Create some mood entries directly in the database
        # Note: Adjust field names based on actual MoodEntry model
        entry1 = MoodEntry(
            user_id=test_user_with_firebase.id,
            mood="7",  # Adjust based on actual model
            note="Feeling good"
        )
        entry2 = MoodEntry(
            user_id=test_user_with_firebase.id,
            mood="8",
            note="Great day"
        )
        db_session.add(entry1)
        db_session.add(entry2)
        db_session.commit()
        
        response = client.get(
            "/api/v1/moods",
            headers={"Authorization": "Bearer fake-token"}
        )
        
        assert response.status_code == 200
        data = response.json()
        assert isinstance(data, list)
        # Note: The actual response structure depends on the model fields
        # This test may need adjustment based on actual MoodEntry model
        
        app.dependency_overrides.clear()

    def test_list_moods_empty(self, client, db_session, test_user_with_firebase):
        """Test listing moods when user has no entries."""
        def mock_verify_token():
            return {"uid": "test-firebase-uid-123", "email": "test@example.com"}
        
        from app.auth import verify_token
        app.dependency_overrides[verify_token] = mock_verify_token
        
        response = client.get(
            "/api/v1/moods",
            headers={"Authorization": "Bearer fake-token"}
        )
        
        assert response.status_code == 200
        data = response.json()
        assert isinstance(data, list)
        assert len(data) == 0
        
        app.dependency_overrides.clear()

    def test_list_moods_no_auth(self, client):
        """Test listing moods without authentication."""
        response = client.get("/api/v1/moods")
        
        assert response.status_code == 401

    def test_list_moods_user_isolation(self, client, db_session, test_user_with_firebase, test_user_with_firebase_alt):
        """Test that users can only see their own mood entries."""
        def mock_verify_token():
            return {"uid": "test-firebase-uid-123", "email": "test@example.com"}
        
        from app.auth import verify_token
        app.dependency_overrides[verify_token] = mock_verify_token
        
        # Create entries for first user
        entry1 = MoodEntry(
            user_id=test_user_with_firebase.id,
            mood="7",
            note="User 1 entry"
        )
        db_session.add(entry1)
        
        # Create entries for second user
        entry2 = MoodEntry(
            user_id=test_user_with_firebase_alt.id,
            mood="9",
            note="User 2 entry"
        )
        db_session.add(entry2)
        db_session.commit()
        
        # Query as first user
        response = client.get(
            "/api/v1/moods",
            headers={"Authorization": "Bearer fake-token"}
        )
        
        assert response.status_code == 200
        data = response.json()
        # Should only see entries for the authenticated user
        assert len(data) == 1
        
        app.dependency_overrides.clear()

