from fastapi import APIRouter, Depends
from app.auth import verify_token
from app.database import SessionLocal
from app.models.mood import MoodEntry
from app.models.user import User

router = APIRouter()

@router.post("/moods")
def create_mood(data: dict, decoded=Depends(verify_token)):
    db = SessionLocal()

    user = db.query(User).filter(User.firebase_uid == decoded["uid"]).first()

    entry = MoodEntry(
        user_id=user.id,
        mood_score=data["mood_score"],
        energy_level=data["energy_level"],
        stress_level=data["stress_level"]
    )

    db.add(entry)
    db.commit()
    db.refresh(entry)

    return {"id": str(entry.id)}

@router.get("/moods")
def list_moods(decoded=Depends(verify_token)):
    db = SessionLocal()
    user = db.query(User).filter(User.firebase_uid == decoded["uid"]).first()

    entries = db.query(MoodEntry).filter(MoodEntry.user_id == user.id).all()

    return [
        {
            "id": str(e.id),
            "mood": e.mood_score,
            "energy": e.energy_level,
            "stress": e.stress_level
        }
        for e in entries
    ]
from app.utils.logging import log_api_call

@router.post("/moods")
def create_mood(data: dict, decoded=Depends(verify_token)):
    ...
    log_api_call("/moods", user_id=str(user.id), extra={"action": "create"})
    ...
