import atexit
from datetime import datetime

from tables import *
from schemas import *
from enums import MealType
from database import SessionLocal


class BaseDBRepository:
    def __init__(self) -> None:
        self.session = SessionLocal()
        atexit.register(lambda: self.session.close())

    def create_user(self, user_name: str) -> UserTable:
        return UserTable(user_name=user_name, food_logs=[])

    def create_food_log(self, meal_type: MealType, date: datetime, foods): ...

    # def get_all(self) -> Sequence[SchemaType]: ...

    # def get_by_id(self, obj_id: int) -> SchemaType | None: ...

    # def update(self, obj_id: int, **kwargs) -> SchemaType | None: ...

    def delete(self, obj_id: int) -> bool: ...
