from models import UserModel
from repositories.postgres.base import BaseDBRepository
from database.database import SessionLocal


class BaseUserRepository(BaseDBRepository[UserModel]):
    ...
