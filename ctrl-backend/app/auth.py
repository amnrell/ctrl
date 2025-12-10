from fastapi import HTTPException, Header
from firebase_admin import auth
import firebase_admin

default_app = firebase_admin.initialize_app()

def verify_token(authorization: str = Header(None)):
    if not authorization:
        raise HTTPException(status_code=401, detail="Missing Authorization header")

    token = authorization.replace("Bearer ", "")

    try:
        decoded = auth.verify_id_token(token)
        return decoded
    except:
        raise HTTPException(status_code=401, detail="Invalid Firebase ID token")
