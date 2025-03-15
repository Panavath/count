import atexit
from datetime import datetime
from typing import Any

from sqlalchemy.orm import Session

from enums.enums import MealType
from models import FoodLogModel
from database.database import SessionLocal
from repositories.postgres.food_log.base_log import BaseFoodLogRepository


class LogRepository(BaseFoodLogRepository):
    def __init__(self) -> None:
        self._db = SessionLocal()
        atexit.register(lambda: self._db.close())
        super().__init__(FoodLogModel)

    @property
    def db(self) -> Session:
        return self._db

    def create(self, *, user_id: int, meal_type: MealType, time: datetime, foods: list[Any], **kwargs) -> FoodLogModel:
        try:
            new_entry = FoodLogModel(
                user_id=user_id,
                meal_type=meal_type,
                time=time,
                foods=foods,
                **kwargs
            )

            self._db.add(new_entry)
            self._db.commit()
            self._db.refresh(new_entry)

            print(f"New entry added for user {new_entry.user_id}:", new_entry)
            return new_entry

        except Exception as e:
            self._db.rollback()
            raise RuntimeError

    def get_all(self) -> list[FoodLogModel]:
        return self.db.query(self.model).all()

    def get_by_id(self, obj_id: int) -> FoodLogModel | None:
        return self.db.query(self.model).filter(self.model.user_id == obj_id).first()

    def update(self, obj_id: int, **kwargs) -> FoodLogModel | None:
        obj = self.get_by_id(obj_id)
        if obj:
            for key, value in kwargs.items():
                setattr(obj, key, value)
            self.db.commit()
            self.db.refresh(obj)
        return obj

    def filter_by(self, **filters) -> list[FoodLogModel]:
        return self.db.query(self.model).filter_by(**filters).all()

    def delete(self, obj_id: int) -> bool:
        obj = self.get_by_id(obj_id)
        if obj:
            self.db.delete(obj)
            self.db.commit()
            return True
        return False
