from sqlalchemy import Column, Integer, Float, ForeignKey, DateTime
from sqlalchemy.orm import relationship
from datetime import datetime

from database.database import Base

class WeightLog(Base):
    __tablename__ = "weight_logs"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    weight_kg = Column(Float)
    date = Column(DateTime, default=datetime.utcnow)

    # Relationship
    user = relationship("User", back_populates="weight_logs")
