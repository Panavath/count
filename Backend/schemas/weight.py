from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class WeightLogBase(BaseModel):
    user_id: int
    weight_kg: Optional[float] = None
    date: Optional[datetime] = None

class WeightLogCreate(WeightLogBase):
    """Schema for creating a new weight log entry."""
    pass

class WeightLogUpdate(BaseModel):
    """Schema for updating existing weight log fields."""
    weight_kg: Optional[float] = None
    date: Optional[datetime] = None

class WeightLog(WeightLogBase):
    """Schema for reading weight log data (includes DB id)."""
    id: int

    class Config:
        from_attributes = True  # Use this instead of orm_mode
