from fastapi import APIRouter

from {{ package_name }}.api.v1.ping import router as ping_router

router = APIRouter(prefix="/api/v1")
router.include_router(ping_router)
