import atexit

from sqlalchemy import Row, select
from sqlalchemy.orm import Session

from models import UserModel
from database.database import SessionLocal
from repositories.postgres.user.base_user import BaseUserRepository


class UserRepository(BaseUserRepository):
    def __init__(self) -> None:
        self._db = SessionLocal()
        atexit.register(lambda: self._db.close())
        super().__init__(UserModel)

    @property
    def db(self) -> Session:
        return self._db

    def create(self, **kwargs) -> UserModel:
        obj = self.model(**kwargs)
        self.db.add(obj)
        self.db.commit()
        self.db.refresh(obj)
        return obj

    def get_all(self) -> list[UserModel]:
        return self.db.query(self.model).all()

    def get_by_id(self, obj_id: int) -> Row[tuple[UserModel]] | None:
        stmt = select(self.model).where(self.model.user_id == obj_id)
        return self.db.execute(stmt).first()

    def update(self, obj_id: int, **kwargs) -> Row[tuple[UserModel]] | None:
        obj = self.get_by_id(obj_id)
        if obj:
            for key, value in kwargs.items():
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
