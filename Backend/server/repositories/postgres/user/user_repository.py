import atexit

from database import SessionLocal
from schemas.user import BaseUserSchema
from tables import UserTable
from .base_user_repository import BaseUserRepository


class UserRepository(BaseUserRepository):
    def __init__(self) -> None:
        self.db_session = SessionLocal()
        atexit.register(lambda: self.db_session.close())
        super().__init__(UserTable)

    def create(self, **kwargs) -> BaseUserSchema:
        return super().create(**kwargs)
