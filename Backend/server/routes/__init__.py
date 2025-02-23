from fastapi import FastAPI, APIRouter

from routes.user import user_router
from routes.log import log_router

def load_routes(app: FastAPI) -> None:
    app.include_router(user_router)
    app.include_router(log_router)
