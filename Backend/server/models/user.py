from datetime import datetime
from sqlalchemy import Column, Integer, String, Float, DateTime, Enum
from sqlalchemy.orm import relationship, Mapped, mapped_column
from typing import TYPE_CHECKING


from database.database import BaseModel
from enums.enums import WeightGoals, MuscleGoals

if TYPE_CHECKING:
    # from models.exercise_log import ExerciseLogModel
    from models.food_log import FoodLogModel
    # from models.weight_log import WeightLogModel


class UserModel(BaseModel):
    __tablename__ = 'User'

    # Columns
    user_id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    username: Mapped[str] = mapped_column(String, nullable=False)
    email: Mapped[str] = mapped_column(String, unique=True, nullable=False)
    password: Mapped[str] = mapped_column(String, nullable=False)
    # dob: Mapped[datetime] = mapped_column(DateTime)
    gender: Mapped[str] = mapped_column(String, nullable=False)
    # height_cm: Mapped[float] = mapped_column(Float)
    # weight_km: Mapped[float] = mapped_column(Float)

    # weight_goal: Mapped[WeightGoals] = mapped_column(Enum(WeightGoals))
    # target_weight: Mapped[float] = mapped_column(Float)

    # muscle_goal: Mapped[MuscleGoals] = mapped_column(Enum(MuscleGoals))

    # Relationships
    food_logs: Mapped['FoodLogModel'] = relationship('FoodLogModel', back_populates='user')
    # exercise_logs: Mapped['ExerciseLogModel'] = relationship('ExerciseLog', back_populates='user')
    # weight_logs: Mapped['WeightLogModel'] = relationship('WeightLog', back_populates='user')
