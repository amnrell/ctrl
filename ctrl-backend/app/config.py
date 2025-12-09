import os
from dotenv import load_dotenv
load_dotenv()

class Settings:
    PROJECT_NAME = "CTRL Backend"
    DATABASE_URL = os.getenv("DATABASE_URL")
    FIREBASE_PROJECT_ID = os.getenv("FIREBASE_PROJECT_ID")

settings = Settings()
import os

DATABASE_URL = os.getenv(
    "DATABASE_URL",
    "postgresql+psycopg://ctrl_user:YOUR_PASSWORD@136.111.82.119:5432/ctrl_db"
)
