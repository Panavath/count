from sqlalchemy import Column, Integer, Float, ForeignKey, DateTime
from sqlalchemy.orm import relationship
from datetime import datetime

from database.database import Base

class ExerciseLog(Base):
    __tablename__ = "exercise_logs"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    exercise_id = Column(Integer, ForeignKey("exercises.id"), nullable=False)
    duration_minutes = Column(Float)
    date = Column(DateTime, default=datetime.utcnow)

    # Relationships
    user = relationship("User", back_populates="exercise_entries")
    exercise = relationship("Exercise")
