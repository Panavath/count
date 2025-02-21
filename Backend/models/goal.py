from sqlalchemy import Column, Integer, Float, ForeignKey
from sqlalchemy.orm import relationship
from database.database import Base

class Goal(Base):
    __tablename__ = "goals"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    target_weight_kg = Column(Float)
    daily_calories_goal = Column(Float)
    protein_goal_g = Column(Float)
    carbs_goal_g = Column(Float)
    fat_goal_g = Column(Float)

    # Relationship
    user = relationship("User", back_populates="goal")
