import os
from dotenv import load_dotenv
load_dotenv()

class Settings:
    PROJECT_NAME = "CTRL Backend"
    DATABASE_URL = os.getenv("DATABASE_URL")
    FIREBASE_PROJECT_ID = os.getenv("FIREBASE_PROJECT_ID")

settings = Settings()
