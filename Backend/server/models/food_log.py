from datetime import datetime

from sqlalchemy import Column, Integer, String, Float, DateTime, Enum, ForeignKey
from sqlalchemy.orm import relationship

from database.database import BaseModel
from enums.enums import MealType


class FoodLogModel(BaseModel):
    __tablename__ = 'FoodLog'

    # Columns
    food_log_id = Column(Integer, primary_key=True, index=True)
    user_id = Column(
        Integer,
        ForeignKey('User.user_id'),
        nullable=False
    )
    meal_type = Column(Enum(MealType))
    date = Column(DateTime, default=datetime.now)

    # Relationships
    user = relationship('UserModel', back_populates='food_logs')
    food = relationship('FoodModel')
