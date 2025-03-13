from models import UserModel

from database.database import SessionLocal
from repositories.postgres.user.base_user import BaseUserRepository


class UserRepository(BaseUserRepository):
    def __init__(self) -> None:
        super().__init__(SessionLocal(), UserModel)

    def create(self, data: dict) -> UserModel:
        obj = self.model(data)
        self.db.add(obj)
        self.db.commit()
        self.db.refresh(obj)
        return obj

    def get_all(self) -> list[UserModel]:
        return self.db.query(self.model).all()

    def get_by_id(self, obj_id: int) -> UserModel | None:
        return self.db.query(self.model).filter(self.model.id == obj_id).first()

    def update(self, obj_id: int, data: dict) -> UserModel | None:
        obj = self.get_by_id(obj_id)
        if obj:
            for key, value in data.items():
                setattr(obj, key, value)
            self.db.commit()
            self.db.refresh(obj)
        return obj

    def filter_by(self, **filters) -> list[UserModel]:
        return self.db.query(self.model).filter_by(**filters).all()

    def delete(self, obj_id: int) -> bool:
        obj = self.get_by_id(obj_id)
        if obj:
            self.db.delete(obj)
            self.db.commit()
            return True
        return False
