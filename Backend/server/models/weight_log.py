from sqlalchemy import Column, Integer, Float, ForeignKey, DateTime
from sqlalchemy.orm import relationship
from datetime import datetime

from database.database import BaseModel


class WeightLogModel(BaseModel):
    __tablename__ = "WeightLog"

    # Columns
    weight_log_id = Column(Integer, primary_key=True, index=True)
    user_id = Column(
        Integer,
        ForeignKey("User.user_id"),
        nullable=False
    )
    weight_kg = Column(Float)
    date = Column(DateTime, default=datetime.now)

    # Relationship
    user = relationship("UserModel", back_populates="weight_logs")
