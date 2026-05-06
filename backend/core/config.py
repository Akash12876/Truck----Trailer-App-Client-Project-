import os
from functools import lru_cache

from dotenv import load_dotenv

load_dotenv()


class Settings:
    database_url: str = os.getenv(
        "DATABASE_URL",
        "postgresql+asyncpg://postgres:password@localhost:5432/truck_trailer_db",
    )
    secret_key: str = os.getenv("SECRET_KEY", "change-me")
    algorithm: str = os.getenv("ALGORITHM", "HS256")
    access_token_expire_minutes: int = int(
        os.getenv("ACCESS_TOKEN_EXPIRE_MINUTES", "30")
    )
    cors_origins: list[str] = [
        origin.strip()
        for origin in os.getenv("CORS_ORIGINS", "*").split(",")
        if origin.strip()
    ]


@lru_cache
def get_settings() -> Settings:
    return Settings()
