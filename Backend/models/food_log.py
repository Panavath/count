from sqlalchemy import Column, Integer, Float, String, ForeignKey, DateTime
from sqlalchemy.orm import relationship
from datetime import datetime

from database.database import Base

class FoodLog(Base):
    __tablename__ = "food_logs"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    food_id = Column(Integer, ForeignKey("foods.id"), nullable=False)
    quantity = Column(Float)
    meal_type = Column(String)
    date = Column(DateTime, default=datetime.utcnow)

    # Relationships
    user = relationship("User", back_populates="food_entries")
    food = relationship("Food")
