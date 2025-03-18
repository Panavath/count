from . import CountRouter

user_router = CountRouter(prefix='/user', tags=['user'])


@user_router.get('/')
async def get_user():
    return {'content': ''}
