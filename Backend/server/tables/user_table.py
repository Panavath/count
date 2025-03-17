from __future__ import annotations

from datetime import datetime
from typing import TYPE_CHECKING

from sqlalchemy import Integer, String
from sqlalchemy.orm import relationship, Mapped, mapped_column

from database import BaseTable
from enums import MealType
from schemas import BaseUserSchema

if TYPE_CHECKING:
    from tables import FoodTable
    from .food_log_table import FoodLogTable


class UserTable(BaseTable):
    __tablename__ = 'User'

    # Columns
    user_id: Mapped[int] = mapped_column(primary_key=True, index=True)
    username: Mapped[str] = mapped_column(nullable=False)

    # Relationships
    food_logs: Mapped[list['FoodLogTable']] = relationship(
        'FoodLogTable', uselist=True, back_populates='user')

    def __init__(
            self, *,
            user_name: str,
            food_logs: list['FoodLogTable'] | None = None,

            meal_type: MealType,
            date: datetime,
            foods: list['FoodTable'],

            name: str,
            serving_size: float,
            unit: str,
            values_calculated: bool,
            calories: float = 0,
            protein_g: float = 0,
            carbs_g: float = 0,
            fat_g: float = 0,
            **kwargs):
        super().__init__(user_name=user_name, **kwargs)

        if food_logs is None:
            food_logs = []
        self.food_logs = food_logs

    def __repr__(self) -> str:
        return f'User({self.username}, id={self.user_id}, food logs={self.food_logs})'
