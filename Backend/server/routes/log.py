from fastapi import APIRouter, HTTPException

from pydantic import BaseModel
# from ..schemas.food_log import BaseFoodLog

class test(BaseModel):
    name: str

__all__ = ['log_router']

log_router = APIRouter(prefix='/log', tags=['log'])


@log_router.get('')
def get_logs():
    return {'message': ''}

@log_router.post('/food')
def log_food(food: test):
    return food
