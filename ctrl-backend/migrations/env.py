import os
from logging.config import fileConfig

from sqlalchemy import create_engine
from alembic import context
from dotenv import load_dotenv

# Load .env file from project root
load_dotenv(".env")

# Alembic Config
config = context.config

# Logging
if config.config_file_name is not None:
    fileConfig(config.config_file_name)

# -----------------------------
# IMPORT MODELS EXPLICITLY
# -----------------------------
from app.database import Base
from app.models import user, mood  # <-- IMPORTANT: import each model module

# Now metadata includes ALL models
target_metadata = Base.metadata

# DB URL from .env
DATABASE_URL = os.getenv("DATABASE_URL")


def run_migrations_offline() -> None:
    """Run migrations without a DB connection."""
    context.configure(
        url=DATABASE_URL,
        target_metadata=target_metadata,
        literal_binds=True,
        dialect_opts={"paramstyle": "named"},
    )

    with context.begin_transaction():
        context.run_migrations()


def run_migrations_online() -> None:
    """Run migrations with a DB connection."""
    connectable = create_engine(DATABASE_URL, pool_pre_ping=True)

    with connectable.connect() as connection:
        context.configure(
            connection=connection,
            target_metadata=target_metadata,
            compare_type=True,
            compare_server_default=True,
        )

        with context.begin_transaction():
            context.run_migrations()


if context.is_offline_mode():
    run_migrations_offline()
else:
    run_migrations_online()
