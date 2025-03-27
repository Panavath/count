from __future__ import annotations

from typing import TYPE_CHECKING, Any
from datetime import datetime

from sqlalchemy import ForeignKey, Integer, String
from sqlalchemy.orm import relationship, Mapped, mapped_column

from database import BaseTable
from enums import MealType

if TYPE_CHECKING:
    from .user_table import UserTable
    from .food_table import FoodTable


class FoodLogTable(BaseTable):
    __tablename__ = 'FoodLog'

    # Columns
    food_log_id: Mapped[int] = mapped_column(
        primary_key=True, index=True, autoincrement=True)
    user_id: Mapped[int] = mapped_column(ForeignKey('User.user_id'))
    name: Mapped[str]
    meal_type: Mapped[MealType]
    date: Mapped[datetime]

    # Relationships
    user: Mapped['UserTable'] = relationship(
        'UserTable', uselist=False, back_populates='food_logs')
    foods: Mapped[list['FoodTable']] = relationship(
        'FoodTable', uselist=True, back_populates='food_log')

    def __init__(
            self, *,
            name: str,
            meal_type: MealType,
            date: datetime,
            foods: list[FoodTable],
            **kwargs
    ):
        super().__init__(name=name, meal_type=meal_type, date=date, foods=foods, **kwargs)

    def __repr__(self) -> str:
        return f'FoodLog({self.meal_type}, date={self.date}, foods={self.foods})'
