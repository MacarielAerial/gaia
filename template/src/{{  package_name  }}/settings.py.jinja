from __future__ import annotations

from pydantic import Field
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    """
    App configuration loaded from environment variables.

    Notes:
      - Uses APP_ prefix by default (e.g. APP_LOG_LEVEL=DEBUG)
      - Reads .env if present (useful for local/dev; harmless in CI/containers)
    """

    model_config = SettingsConfigDict(
        env_prefix="APP_",
        env_file=".env",
        env_file_encoding="utf-8",
        extra="ignore",
    )

    app_name: str = Field(default="{{ project_name | default('FastAPI Service') }}")
    environment: str = Field(default="dev")  # dev|staging|prod etc.

    # Convenience (you can still drive uvicorn via CLI)
    host: str = Field(default="0.0.0.0")
    port: int = Field(default=8000)

    # Logging
    log_level: str = Field(default="INFO")  # DEBUG|INFO|WARNING|ERROR
    log_json: bool = Field(default=False)


def get_settings() -> Settings:
    return Settings()
