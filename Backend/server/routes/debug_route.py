from services import DatabaseService
from . import CountRouter
from datetime import datetime

from fastapi import HTTPException, Depends

from config import ENV_MODE
from database import *

debug_router = CountRouter(prefix='/debug')


@debug_router.get('/drop-tables')
async def drop_tables_route():
    if ENV_MODE != 'DEV':
        raise HTTPException(405, 'Operation not allowed')
    drop_all_tables()
    return {'message': 'Tables dropped successfully'}


@debug_router.get('/create-tables')
async def create_tables_route():
    if ENV_MODE != 'DEV':
        raise HTTPException(405, 'Operation not allowed')
    create_tables()
    return {'message': 'Tables created successfully'}


@debug_router.get('/seed-tables')
async def seed_tables_route():
    if ENV_MODE != 'DEV':
        raise HTTPException(405, 'Operation not allowed')
    DatabaseService.new_user(
        user_name='Hout Manut',
        dob=datetime(2004, 7, 6),
        gender='male',
        height=165,
        weight=50,
    )

    return {'message': 'Tables seeded successfully'}

# @debug_router.get('/reset')
# async def reset_db_route():
#     if ENV_MODE != 'DEV':
#         raise HTTPException(405, 'Operation not allowed')
#     drop_all_tables()
#     create_tables()
#     DatabaseService.new_user('Hout Manut')
#     return 200
