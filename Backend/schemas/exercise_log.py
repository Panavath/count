from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class ExerciseLogBase(BaseModel):
    user_id: int
    exercise_id: int
    duration_minutes: Optional[float] = None
    date: Optional[datetime] = None

class ExerciseLogCreate(ExerciseLogBase):
    """Schema for creating a new exercise log entry."""
    pass

class ExerciseLogUpdate(BaseModel):
    """Schema for updating existing exercise log fields."""
    duration_minutes: Optional[float] = None
    date: Optional[datetime] = None

class ExerciseLog(ExerciseLogBase):
    """Schema for reading exercise log data (includes DB id)."""
    id: int

    class Config:
        from_attributes = True  # Use this instead of orm_mode
