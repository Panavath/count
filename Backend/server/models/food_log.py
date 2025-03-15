from datetime import datetime
from typing import TYPE_CHECKING

from sqlalchemy import Integer, DateTime, Enum, ForeignKey
from sqlalchemy.orm import relationship, Mapped, mapped_column

from database.database import BaseModel
from enums.enums import MealType

from .user import UserModel
from .food import FoodModel


class FoodLogModel(BaseModel):
    __tablename__ = 'FoodLog'

    # Columns
    food_log_id: Mapped[int] = mapped_column(
        Integer, primary_key=True, index=True)
    user_id: Mapped[int] = mapped_column(
        Integer,
        ForeignKey('User.user_id'),
        nullable=False
    )
    meal_type: Mapped[MealType] = mapped_column(Enum(MealType))
    date: Mapped[datetime] = mapped_column(DateTime, default=datetime.now)

    # Relationships
    user: Mapped[UserModel] = relationship('UserModel', back_populates='food_logs')
    food: Mapped[FoodModel] = relationship('FoodModel')
