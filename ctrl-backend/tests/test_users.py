import pytest
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.pool import StaticPool
from unittest.mock import patch

# Import after conftest.py sets environment variables
from app.main import app
from app.database import Base, get_db
from app.models.user import User
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


class TestGetMe:
    """Test cases for GET /users/me endpoint."""

    def test_get_me_existing_user(self, client, db_session, test_user_with_firebase):
        """Test successful retrieval of existing user."""
        # Override the verify_token dependency
        def mock_verify_token():
            return {"uid": "test-firebase-uid-123", "email": "test@example.com"}
        
        app.dependency_overrides[verify_token] = mock_verify_token
        
        # Patch SessionLocal to use test database session
        with patch('app.routers.users.SessionLocal', return_value=db_session):
            response = client.get(
                "/api/v1/me",
                headers={"Authorization": "Bearer fake-token"}
            )
        
        assert response.status_code == 200
        data = response.json()
        assert data["id"] == str(test_user_with_firebase.id)
        assert data["firebase_uid"] == "test-firebase-uid-123"
        
        app.dependency_overrides.clear()

    def test_get_me_new_user_creation(self, client, db_session):
        """Test that a new user is created when user doesn't exist."""
        # Override the verify_token dependency
        def mock_verify_token():
            return {"uid": "new-firebase-uid-789", "email": "newuser@example.com"}
        
        app.dependency_overrides[verify_token] = mock_verify_token
        
        # Patch SessionLocal to use test database session
        with patch('app.routers.users.SessionLocal', return_value=db_session):
            response = client.get(
                "/api/v1/me",
                headers={"Authorization": "Bearer fake-token"}
            )
        
        assert response.status_code == 200
        data = response.json()
        assert "id" in data
        assert data["firebase_uid"] == "new-firebase-uid-789"
        
        # Verify the user was actually created in the database
        created_user = db_session.query(User).filter(
            User.firebase_uid == "new-firebase-uid-789"
        ).first()
        assert created_user is not None
        assert str(created_user.id) == data["id"]
        
        app.dependency_overrides.clear()

    def test_get_me_no_auth(self, client):
        """Test /me endpoint without authentication token."""
        response = client.get("/api/v1/me")
        assert response.status_code == 401
        assert "Missing Authorization header" in response.json()["detail"]

    def test_get_me_invalid_token_format(self, client):
        """Test /me endpoint with invalid token format."""
        response = client.get(
            "/api/v1/me",
            headers={"Authorization": "InvalidFormat token"}
        )
        assert response.status_code == 401
        assert "Invalid Authorization header format" in response.json()["detail"]

    def test_get_me_missing_bearer(self, client):
        """Test /me endpoint without Bearer prefix."""
        response = client.get(
            "/api/v1/me",
            headers={"Authorization": "fake-token"}
        )
        assert response.status_code == 401
        assert "Invalid Authorization header format" in response.json()["detail"]

    def test_get_me_invalid_token(self, client):
        """Test /me endpoint with invalid Firebase token."""
        # Don't override verify_token, let it fail with invalid token
        response = client.get(
            "/api/v1/me",
            headers={"Authorization": "Bearer invalid_token_here"}
        )
        assert response.status_code == 401
        assert "Invalid or expired Firebase ID token" in response.json()["detail"]

    def test_get_me_user_isolation(self, client, db_session, test_user_with_firebase, test_user_with_firebase_alt):
        """Test that users can only retrieve their own data."""
        # Override the verify_token dependency for first user
        def mock_verify_token():
            return {"uid": "test-firebase-uid-123", "email": "test@example.com"}
        
        app.dependency_overrides[verify_token] = mock_verify_token
        
        # Patch SessionLocal to use test database session
        with patch('app.routers.users.SessionLocal', return_value=db_session):
            response = client.get(
                "/api/v1/me",
                headers={"Authorization": "Bearer fake-token"}
            )
        
        assert response.status_code == 200
        data = response.json()
        assert data["id"] == str(test_user_with_firebase.id)
        assert data["firebase_uid"] == "test-firebase-uid-123"
        # Should not return the other user's data
        assert data["id"] != str(test_user_with_firebase_alt.id)
        
        app.dependency_overrides.clear()

    def test_get_me_multiple_calls_same_user(self, client, db_session):
        """Test that multiple calls with same firebase_uid return same user."""
        # Override the verify_token dependency
        def mock_verify_token():
            return {"uid": "test-firebase-uid-999", "email": "test@example.com"}
        
        app.dependency_overrides[verify_token] = mock_verify_token
        
        # Patch SessionLocal to use test database session
        with patch('app.routers.users.SessionLocal', return_value=db_session):
            # First call - should create user
            response1 = client.get(
                "/api/v1/me",
                headers={"Authorization": "Bearer fake-token"}
            )
            assert response1.status_code == 200
            data1 = response1.json()
            user_id_1 = data1["id"]
            
            # Second call - should return same user
            response2 = client.get(
                "/api/v1/me",
                headers={"Authorization": "Bearer fake-token"}
            )
            assert response2.status_code == 200
            data2 = response2.json()
            user_id_2 = data2["id"]
            
            # Should be the same user
            assert user_id_1 == user_id_2
            assert data1["firebase_uid"] == data2["firebase_uid"]
        
        app.dependency_overrides.clear()

    def test_get_me_response_structure(self, client, db_session, test_user_with_firebase):
        """Test that response has correct structure."""
        def mock_verify_token():
            return {"uid": "test-firebase-uid-123", "email": "test@example.com"}
        
        app.dependency_overrides[verify_token] = mock_verify_token
        
        with patch('app.routers.users.SessionLocal', return_value=db_session):
            response = client.get(
                "/api/v1/me",
                headers={"Authorization": "Bearer fake-token"}
            )
        
        assert response.status_code == 200
        data = response.json()
        # Verify response structure
        assert "id" in data
        assert "firebase_uid" in data
        assert isinstance(data["id"], str)
        assert isinstance(data["firebase_uid"], str)
        # Should not contain sensitive information
        assert "email" not in data
        assert "hashed_password" not in data
        assert "password" not in data
        
        app.dependency_overrides.clear()

