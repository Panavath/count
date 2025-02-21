from sqlalchemy import Column, Integer, String, Float
from sqlalchemy.orm import relationship
from database.database import Base

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    username = Column(String, unique=True, nullable=False)
    email = Column(String, unique=True, nullable=False)
    hashed_password = Column(String, nullable=False)
    age = Column(Integer)
    gender = Column(String)
    height_cm = Column(Float)
    weight_kg = Column(Float)

    # Relationships to logs/goals
    food_entries = relationship("FoodLog", back_populates="user")
    exercise_entries = relationship("ExerciseLog", back_populates="user")
    goal = relationship("Goal", uselist=False, back_populates="user")
    weight_logs = relationship("WeightLog", back_populates="user")
