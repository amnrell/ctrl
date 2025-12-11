from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.routers import auth, health, users, moods
from app.utils.swagger_oauth_fix import fix_swagger_login


app = FastAPI(title="CTRL Backend")


# -----------------------------
# FIX SWAGGER AUTH LOGIN
# -----------------------------
@app.get("/openapi.json", include_in_schema=False)
def overridden_openapi():
    return fix_swagger_login(app)


# -----------------------------
# ROUTE PREFIX
# -----------------------------
API_PREFIX = "/api/v1"


# -----------------------------
# ROUTERS (Include Each Once)
# -----------------------------
app.include_router(health.router, prefix=API_PREFIX, tags=["health"])
app.include_router(users.router, prefix=API_PREFIX, tags=["users"])
app.include_router(moods.router, prefix=API_PREFIX, tags=["moods"])
app.include_router(auth.router, prefix=API_PREFIX, tags=["auth"])


# -----------------------------
# CORS — Fixes "Failed to fetch"
# -----------------------------
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],        # change to specific domain in production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
