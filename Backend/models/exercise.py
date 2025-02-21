from sqlalchemy import Column, Integer, String, Float
from database.database import Base

class Exercise(Base):
    __tablename__ = "exercises"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    calories_burned_per_minute = Column(Float)
