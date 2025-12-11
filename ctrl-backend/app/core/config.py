from pathlib import Path
from dotenv import load_dotenv
import os

BASE_DIR = Path(__file__).resolve().parents[2]   # <-- GO UP TO PROJECT ROOT
ENV_PATH = BASE_DIR / ".env"

load_dotenv(ENV_PATH)

class Settings:
    PROJECT_NAME = "CTRL Backend"

    DATABASE_URL = os.getenv("DATABASE_URL")

    SECRET_KEY = os.getenv("SECRET_KEY", "change_me_in_env")
    ALGORITHM = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES = 60

    FIREBASE_PROJECT_ID = os.getenv("FIREBASE_PROJECT_ID")

settings = Settings()

print("DEBUG: DATABASE_URL =", settings.DATABASE_URL)
