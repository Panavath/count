from . import CountRouter
from typing import Callable

from fastapi import HTTPException, Depends

from config import ENV_MODE
from database import *

debug_router = CountRouter(prefix='/debug')


def check_is_dev(func: Callable):

    async def wrapper(*args, **kwargs):
        if ENV_MODE != 'DEV':
            raise HTTPException(405, 'Operation not allowed')
        return await func(*args, **kwargs)

    return wrapper


@debug_router.get('/drop-tables')
@check_is_dev
async def drop_tables_route():
    drop_all_tables()
    return {"message": "Tables dropped successfully"}


@debug_router.get('/drop-tables')
@check_is_dev
async def create_tables_route():
    create_tables()
    return {"message": "Tables created successfully"}


@debug_router.get('/seed_tables')
@check_is_dev
async def seed_tables_route():
    seed_all()
    return {"message": "Tables seeded successfully"}
