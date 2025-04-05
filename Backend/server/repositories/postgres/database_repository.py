import atexit
from typing import Iterable, Literal
from datetime import datetime

from sqlalchemy import select, update, delete

from tables import *
from schemas import *
from enums import MealType
from database import SessionLocal, BaseTable

from dto import *
from other.exceptions import DoesNotExistException


class BaseDBRepository:
    def __init__(self) -> None:
        self.session = SessionLocal()
        atexit.register(lambda: self.session.close())

    def __add_commit_refresh(self, data: BaseTable | Iterable[BaseTable]) -> None:
        try:
            if (isinstance(data, Iterable)):
                self.session.add_all(data)
            else:
                self.session.add(data)
            self.session.commit()
            self.session.refresh(data)
        except Exception as e:
            self.session.rollback()
            raise e

    def create_user(
        self,    *,
        user_name: str,
        dob: datetime,
        gender: Literal['male', 'female'],
        height: float,
        weight: float,
        height_goal: float | None,
        weight_goal: float | None,
        calory_goal: float | None,
    ) -> UserSchema:
        if height_goal is not None and height_goal <= 0:
            height_goal = None
        if weight_goal is not None and weight_goal <= 0:
            weight_goal = None
        if calory_goal is not None and calory_goal <= 0:
            calory_goal = None
        new_user = UserTable(
            user_name=user_name,
            dob=dob,
            gender=gender,
            height=height,
            weight=weight,
            height_goal=height_goal,
            weight_goal=weight_goal,
            calory_goal=calory_goal,
            food_logs=[],
            weight_logs=[],
            height_logs=[],
        )

        self.__add_commit_refresh(new_user)
        return UserDto.from_table_to_schema(new_user)

    def get_user_schema_by_id(self, user_id: int) -> UserSchema:
        return UserDto.from_table_to_schema(self.get_user_table_by_id(user_id))

    def get_user_table_by_id(self, user_id: int) -> UserTable:
        result = self.session.query(UserTable).where(
            UserTable.user_id == user_id).first()

        if result is None:
            raise DoesNotExistException(
                f'User with id: {user_id} does not exist'
            )

        return result

    def add_food_log(self, user_id: int, log_name: str, meal_type: MealType, date: datetime, foods: list[FoodSchema]) -> UserSchema:
        user = self.get_user_table_by_id(user_id)

        new_food_log = FoodLogTable(
            name=log_name,
            meal_type=meal_type,
            date=date,
            foods=[FoodDTO.from_schema_to_table(food) for food in foods]
        )

        user.food_logs.append(new_food_log)
        self.__add_commit_refresh(new_food_log)

        return UserDto.from_table_to_schema(user)

    def delete_food_log(self, log_id: int) -> int:
        stmt = delete(FoodLogTable).where(FoodLogTable.food_log_id == log_id)
        result = self.session.execute(stmt)
        self.session.commit()

        return result.rowcount


    def get_all_users(self) -> list[UserSchema]:
        users = self.session.query(UserTable).all()

        return [UserDto.from_table_to_schema(user) for user in users]

    # def get_all(self) -> Sequence[SchemaType]: ...

    # def get_by_id(self, obj_id: int) -> SchemaType | None: ...

    # def update(self, obj_id: int, **kwargs) -> SchemaType | None: ...

    def delete_user(self, user_id: int) -> int:
        stmt = delete(UserTable).where(UserTable.user_id == user_id)
        result = self.session.execute(stmt)
        self.session.commit()

        return result.rowcount
