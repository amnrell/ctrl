
from fastapi import FastAPI
from app.routers import health, users, moods

app = FastAPI(title="CTRL Backend")

API_PREFIX = "/api/v1"

app.include_router(health.router, prefix=API_PREFIX, tags=["health"])
app.include_router(users.router, prefix=API_PREFIX, tags=["users"])
app.include_router(moods.router, prefix=API_PREFIX, tags=["moods"])
