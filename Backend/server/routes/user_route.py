from fastapi import HTTPException, Query

from schemas.user import UserCreationSchema
from config import ENV_MODE
from services.database_service import DatabaseService

from . import CountRouter
from other.exceptions import DoesNotExistException

user_router = CountRouter(prefix='/user', tags=['user'])


@user_router.get('/')
async def get_user(user_id: int = Query(...)):
    try:
        return DatabaseService.get_user_by_id(user_id)
    except DoesNotExistException as e:
        raise HTTPException(404, e.args[0])


@user_router.get('/all/')
async def get_all_users():
    if ENV_MODE != 'DEV':
        raise HTTPException(405, 'Operation not allowed')
    return {'users': DatabaseService.get_all_users()}


@user_router.post('/')
async def new_user(user: UserCreationSchema):
    return DatabaseService.new_user(
        user_name=user.user_name,
        dob=user.dob,
        gender=user.gender,
        height=user.height,
        weight=user.weight,
        height_goal=user.height_goal,
        weight_goal=user.weight_goal,
        calory_goal=user.calory_goal,
    )


@user_router.delete('/')
async def delete_user(user_id: int = Query(...)):
    return DatabaseService.delete_user_by_id(user_id)
