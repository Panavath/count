from models import UserModel
from repositories.postgres.user.base_user import BaseUserRepository

from other.utils import Path, Log


class MockUserRepository(BaseUserRepository):
    fake_db: list[UserModel]

    def __init__(self) -> None:
        self.fake_db = []
        super().__init__(None, UserModel)

    def create(self, data: dict) -> UserModel:
        Log.print_debug('New user created:', data)
        obj = self.model(data)
        self.fake_db.append(obj)
        return obj

    def get_all(self) -> list[UserModel]:
        return self.fake_db

    def get_by_id(self, obj_id: int) -> UserModel | None:
        return self.fake_db[0]

    def update(self, obj_id: int, data: dict) -> UserModel | None:
        obj = self.get_by_id(obj_id)
        return obj

    def filter_by(self, **filters) -> list[UserModel]:
        return self.fake_db

    def delete(self, obj_id: int) -> bool:
        return True

    def commit(self):
        Path.save_cache('temp_user.txt', str(self.fake_db))
