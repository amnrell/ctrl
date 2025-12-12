"""
Pytest configuration and fixtures for testing.
This file is automatically loaded by pytest.
"""
import os
import sys
import tempfile
from pathlib import Path

# Create a temporary file for the test database
_test_db_file = tempfile.NamedTemporaryFile(delete=False, suffix='.db')
_test_db_path = _test_db_file.name
_test_db_file.close()

# Set test environment variables BEFORE importing app modules
os.environ["DATABASE_URL"] = f"sqlite:///{_test_db_path}"
os.environ["SECRET_KEY"] = "test-secret-key-for-testing-only-do-not-use-in-production"
# Suppress passlib warnings about bcrypt version detection
os.environ["PASSLIB_SUPPRESS_WARNINGS"] = "1"

# Add the parent directory to the path so we can import app modules
sys.path.insert(0, str(Path(__file__).parent.parent))

# Pre-initialize password context to avoid bcrypt compatibility issues during tests
# This must be done before importing app modules that use security functions
try:
    from passlib.context import CryptContext
    _ = CryptContext(schemes=["bcrypt"], deprecated="auto").hash("test")
except Exception:
    # If initialization fails, continue anyway - tests will handle it
    pass

# Cleanup function to remove test database file
def pytest_sessionfinish(session, exitstatus):
    """Clean up test database file after all tests."""
    try:
        if os.path.exists(_test_db_path):
            os.unlink(_test_db_path)
    except Exception:
        pass

