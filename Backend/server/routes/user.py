from . import Router

__all__ = ['user_router']

user_router = Router(prefix='/user', tags=['user'])


@user_router.r.get('/')
def get_user():
    return {'content': ''}
