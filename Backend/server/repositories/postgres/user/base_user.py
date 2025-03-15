from abc import ABC, abstractmethod
from typing import Sequence

from sqlalchemy import Row

from models import UserModel
from repositories.postgres.base import BaseDBRepository
from schemas.user import BaseUser


class BaseUserRepository(BaseDBRepository[UserModel, BaseUser]):
    @abstractmethod
    def create(self, **kwargs) -> UserModel: ...

    @abstractmethod
    def get_all(self) -> Sequence[UserModel]: ...

    @abstractmethod
    def get_by_id(self, obj_id: int) -> Row[tuple[UserModel]] | None: ...

    @abstractmethod
    def update(self, obj_id: int, **kwargs) -> Row[tuple[UserModel]] | None: ...

    @abstractmethod
    def filter_by(self, **filters) -> Sequence[UserModel]: ...

    @abstractmethod
    def delete(self, obj_id: int) -> bool: ...
