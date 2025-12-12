from datetime import datetime, timedelta
from jose import jwt, JWTError
import bcrypt

from app.core.config import settings  # FIXED IMPORT
from app.schemas.auth import TokenData


def hash_password(password: str) -> str:
    """Hash a password using bcrypt."""
    # Convert password to bytes if it's a string
    password_bytes = password.encode('utf-8') if isinstance(password, str) else password
    # Generate salt and hash password
    salt = bcrypt.gensalt()
    hashed = bcrypt.hashpw(password_bytes, salt)
    # Return as string (bcrypt hash is already base64 encoded)
    return hashed.decode('utf-8')


def verify_password(plain_password: str, hashed_password: str) -> bool:
    """Verify a password against a bcrypt hash."""
    # Convert to bytes if strings
    password_bytes = plain_password.encode('utf-8') if isinstance(plain_password, str) else plain_password
    hash_bytes = hashed_password.encode('utf-8') if isinstance(hashed_password, str) else hashed_password
    # Verify password
    return bcrypt.checkpw(password_bytes, hash_bytes)


def create_access_token(data: dict, expires_delta: timedelta | None = None) -> str:
    to_encode = data.copy()

    expire = datetime.utcnow() + (expires_delta or timedelta(
        minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES
    ))

    to_encode.update({"exp": expire})

    encoded = jwt.encode(
        to_encode,
        settings.SECRET_KEY,
        algorithm=settings.ALGORITHM
    )

    return encoded


def decode_access_token(token: str) -> TokenData:
    try:
        payload = jwt.decode(
            token,
            settings.SECRET_KEY,
            algorithms=[settings.ALGORITHM]
        )
        user_id = payload.get("sub")
        # Convert string to int since JWT stores it as string but TokenData expects int
        if user_id:
            try:
                user_id = int(user_id)
            except (ValueError, TypeError):
                return None
        return TokenData(user_id=user_id)
    except JWTError:
        return None
