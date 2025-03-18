from abc import ABC, abstractmethod
from typing import Sequence

from tables import UserTable
from schemas import BaseUserSchema
from repositories.postgres.base import BaseDBRepository

class BaseUserRepository(BaseDBRepository[UserTable, BaseUserSchema]):
    ...
