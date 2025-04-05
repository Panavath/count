from __future__ import annotations

from datetime import datetime
from typing import TYPE_CHECKING

from sqlalchemy import func
from sqlalchemy.orm import relationship, Mapped, mapped_column

from database import BaseTable
from .food_log_table import FoodLogTable
from .other_log_table import WeightLogTable, HeightLogTable


class UserTable(BaseTable):
    __tablename__ = 'User'

    # Columns
    user_id: Mapped[int] = mapped_column(
        primary_key=True, index=True, autoincrement=True)
    user_name: Mapped[str] = mapped_column(nullable=False)
    dob: Mapped[datetime]
    gender: Mapped[str]
    height: Mapped[float]
    weight: Mapped[float]

    height_goal: Mapped[float | None]
    weight_goal: Mapped[float | None]
    calory_goal: Mapped[float | None]

    register_date: Mapped[datetime] = mapped_column(
        server_default=func.now())

    # Relationships
    food_logs: Mapped[list['FoodLogTable']] = relationship(
        'FoodLogTable', uselist=True, back_populates='user')
    weight_logs: Mapped[list['WeightLogTable']] = relationship(
        'WeightLogTable', uselist=True, back_populates='user')
    height_logs: Mapped[list['HeightLogTable']] = relationship(
        'HeightLogTable', uselist=True, back_populates='user')

    def __init__(
            self, *,
            user_name: str,
            dob: datetime,
            gender: str,
            height: float,
            weight: float,
            height_goal: float | None,
            weight_goal: float | None,
            calory_goal: float | None,
            food_logs: list['FoodLogTable'],
            weight_logs: list['WeightLogTable'],
            height_logs: list['HeightLogTable'],
            **kwargs,
    ):
        super().__init__(
            user_name=user_name,
            food_logs=food_logs,
            dob=dob,
            gender=gender,
            height=height,
            weight=weight,
            height_goal=height_goal,
            weight_goal=weight_goal,
            calory_goal=calory_goal,
            **kwargs,
        )

        if food_logs is None:
            food_logs = []
        if weight_logs is None:
            weight_logs = []
        if height_logs is None:
            height_logs = []

        self.food_logs = food_logs
        self.weight_logs = weight_logs
        self.height_logs = height_logs

    def __repr__(self) -> str:
        return f'User({self.user_name}, id={self.user_id}, food logs={self.food_logs})'
