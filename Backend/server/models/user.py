from sqlalchemy import Column, Integer, String, Float, DateTime, Enum
from sqlalchemy.orm import relationship

from database.database import BaseModel
from enums.enums import WeightGoals, MuscleGoals


class UserModel(BaseModel):
    __tablename__ = 'User'

    # Columns
    user_id = Column(Integer, primary_key=True, index=True)
    username = Column(String, nullable=False)
    email = Column(String, unique=True, nullable=False)
    password = Column(String, nullable=False)
    dob = Column(DateTime)
    gender = Column(String, nullable=False)
    height_cm = Column(Float)
    weight_km = Column(Float)

    weight_goal = Column(Enum(WeightGoals))
    target_weight = Column(Float)

    muscle_goal = Column(Enum(MuscleGoals))

    # Relationships
    food_logs = relationship('FoodLog', back_populates='user')
    exercise_logs = relationship('ExerciseLog', back_populates='user')
    weight_logs = relationship('WeightLog', back_populates='user')
