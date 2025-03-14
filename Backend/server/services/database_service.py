from __future__ import annotations

from repositories import BaseUserRepository
from other.utils import Log


class DatabaseService:
    _instance: DatabaseService | None = None
    _user_repository: BaseUserRepository

    @classmethod
    def get_instance(cls) -> DatabaseService:
        if cls._instance is None:
            raise RuntimeError('Edamam service is not initialized.')

        return cls._instance

    @property
    def user_repository(self) -> BaseUserRepository:
        return self._user_repository

    @classmethod
    def initialize(
        cls, *,
        user_db_repo: BaseUserRepository
    ) -> None:
        Log.print_debug(
            'Database service initialized with db:', type(user_db_repo).__name__
        )
        instance = DatabaseService()
        instance._user_repository = user_db_repo
        cls._instance = instance
