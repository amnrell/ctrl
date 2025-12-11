from fastapi import Header, HTTPException, Depends
from firebase_admin import auth
import firebase_admin

# Only initialize Firebase once
if not firebase_admin._apps:
    firebase_admin.initialize_app()

def verify_token(authorization: str = Header(None)):
    if not authorization:
        raise HTTPException(
            status_code=401, 
            detail="Missing Authorization header"
        )

    # Expect "Bearer <token>"
    parts = authorization.split(" ")

    if len(parts) != 2 or parts[0] != "Bearer":
        raise HTTPException(
            status_code=401, 
            detail="Invalid Authorization header format"
        )

    token = parts[1]

    try:
        decoded_token = auth.verify_id_token(token)
        return decoded_token  # contains uid, email, etc.
    except Exception as e:
        raise HTTPException(
            status_code=401,
            detail="Invalid or expired Firebase ID token"
        )
