from fastapi import APIRouter, Depends
from app.auth import verify_token
from app.database import SessionLocal
from app.models.user import User

router = APIRouter()

@router.get("/me")
def get_me(decoded=Depends(verify_token)):
    firebase_uid = decoded["uid"]
    db = SessionLocal()

    user = db.query(User).filter(User.firebase_uid == firebase_uid).first()

    if not user:
        new_user = User(firebase_uid=firebase_uid)
        db.add(new_user)
        db.commit()
        db.refresh(new_user)
        return {"id": str(new_user.id), "firebase_uid": firebase_uid}

    return {"id": str(user.id), "firebase_uid": firebase_uid}
