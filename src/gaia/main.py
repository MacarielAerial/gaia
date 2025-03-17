from typing import Dict

from fastapi import APIRouter, FastAPI

from gaia.nodes.project_logging import default_logging

default_logging()


# Define an API router for versioned routes.
# Use an extra api router instance to leave the root path open for health check
api_router = APIRouter(prefix="/api/v1")

# Define the top level instance
app = FastAPI(title="Example API", description="Example description", version="0.0.1")
app.include_router(api_router)


@app.get("/health-check")
async def health_check() -> Dict[str, str]:
    return {"message": "The application is running"}
