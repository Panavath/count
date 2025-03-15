from __future__ import annotations

from sqlalchemy import Row

from models.food_log import FoodLogModel
from models.user import UserModel
from repositories import BaseUserRepository, BaseFoodLogRepository
from schemas.food_log import BaseFoodLog
from other.utils import Log


class DatabaseService:
    _instance: DatabaseService | None = None
    _user_repository: BaseUserRepository
    _log_repository: BaseFoodLogRepository

    @classmethod
    def get_instance(cls) -> DatabaseService:
        if cls._instance is None:
            raise RuntimeError('Edamam service is not initialized.')

        return cls._instance

    @property
    def user_repository(self) -> BaseUserRepository:
        return self._user_repository

    @property
    def log_repository(self) -> BaseFoodLogRepository:
        return self._log_repository

    @classmethod
    def initialize(
        cls, *,
        user_db_repo: BaseUserRepository,
        food_log_repo: BaseFoodLogRepository
    ) -> None:
        Log.print_debug(
            'Database service initialized with db:',
            type(user_db_repo).__name__
        )
        instance = DatabaseService()
        instance._user_repository = user_db_repo
        instance._log_repository = food_log_repo
        cls._instance = instance

    @classmethod
    def add_food_log(cls, user_id: int, food_log: BaseFoodLog) -> FoodLogModel:
        Log.print_debug(
            f'Added food log to user {user_id}:', food_log
        )
        return cls.get_instance()._log_repository.create(user_id=user_id, **food_log.model_dump())

    @classmethod
    def get_user_by_id(cls, user_id: int) -> Row[tuple[UserModel]] | None:
        return cls.get_instance().user_repository.get_by_id(user_id)

    @classmethod
    def get_log_of_user(cls, user_id: int):
        return cls.get_instance().log_repository.get_by_user_id(user_id)
