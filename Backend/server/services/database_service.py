from __future__ import annotations
from datetime import datetime
from typing import Literal

from sqlalchemy import Row

from tables import FoodLogTable
from tables import UserTable
from repositories import BaseDBRepository
from schemas import *
from other.utils import Log
from dto import FoodDTO


class DatabaseService:
    _instance: DatabaseService | None = None
    _db_repository: BaseDBRepository

    @classmethod
    def get_instance(cls) -> DatabaseService:
        if cls._instance is None:
            raise RuntimeError('Edamam service is not initialized.')

        return cls._instance

    @property
    def db_repo(self) -> BaseDBRepository:
        return self._db_repository

    @classmethod
    def initialize(
        cls, *,
        db_repo: BaseDBRepository,
    ) -> None:
        Log.print_debug(
            'Database service initialized with db:',
            type(db_repo).__name__
        )
        instance = DatabaseService()
        instance._db_repository = db_repo
        cls._instance = instance

    @classmethod
    def new_user(
        cls, *,
        user_name: str,
        dob: datetime,
        gender: Literal['male', 'female'],
        height: float,
        weight: float,
        height_goal: float | None,
        weight_goal: float | None,
        calory_goal: float | None,
    ) -> UserSchema:
        return cls.get_instance().db_repo.create_user(
            user_name=user_name,
            dob=dob,
            gender=gender,
            height=height,
            weight=weight,
            height_goal=height_goal,
            weight_goal=weight_goal,
            calory_goal=calory_goal,
        )

    @classmethod
    def add_food_log(cls, user_id: int, food_log: FoodLogSchema) -> UserSchema:
        Log.print_debug(
            f'Added food log to user {user_id}:', food_log
        )
        return cls.get_instance().db_repo.add_food_log(user_id=user_id, log_name=food_log.name, meal_type=food_log.meal_type, date=food_log.date, foods=food_log.foods)

    @classmethod
    def delete_food_log(cls, log_id: int) -> int:
        return cls.get_instance().db_repo.delete_food_log(log_id)

    @classmethod
    def get_user_by_id(cls, user_id: int) -> UserSchema:
        return cls.get_instance().db_repo.get_user_schema_by_id(user_id)

    @classmethod
    def get_all_users(cls) -> list[UserSchema]:
        return cls.get_instance().db_repo.get_all_users()

    @classmethod
    def delete_user_by_id(cls, user_id: int) -> int:
        return cls.get_instance().db_repo.delete_user(user_id)
