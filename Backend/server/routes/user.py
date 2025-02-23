from fastapi import APIRouter, HTTPException

__all__ = ['user_router']

user_router = APIRouter(prefix='/user', tags=['user'])


@user_router.get('/')
def get_user():
    return {'content': ''}
