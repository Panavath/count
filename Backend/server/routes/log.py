from . import Router

from pydantic import BaseModel
# from ..schemas.food_log import BaseFoodLog

class test(BaseModel):
    name: str

log_router = Router(prefix='/log', tags=['log'])


@log_router.r.get('')
def get_logs():
    return {'message': ''}

@log_router.r.post('/food')
def log_food(food: test):
    return food
