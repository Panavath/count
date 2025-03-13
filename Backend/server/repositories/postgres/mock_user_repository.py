from models import UserModel
from repositories.postgres.base import BaseRepository


class MockUserRepository(BaseRepository[UserModel]):
    fake_db: list[UserModel]

    def __init__(self) -> None:
        self.fake_db = []
        super().__init__(None, UserModel)

    def create(self, data: dict) -> UserModel:
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
