import logging

logger = logging.getLogger("ctrl-backend")
logging.basicConfig(level=logging.INFO)

def log_api_call(path: str, user_id: str | None = None, extra: dict | None = None):
    logger.info(
        "api_call",
        extra={
            "path": path,
            "user_id": user_id,
            "extra": extra or {},
        },
    )
