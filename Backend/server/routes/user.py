from . import Router

user_router = Router(prefix='/user', tags=['user'])


@user_router.r.get('/')
def get_user():
    return {'content': ''}
