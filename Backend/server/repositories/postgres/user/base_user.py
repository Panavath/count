from models import UserModel
from repositories.postgres.base import BaseDBRepository
from schemas.user import BaseUser


class BaseUserRepository(BaseDBRepository[UserModel, BaseUser]):
    ...
