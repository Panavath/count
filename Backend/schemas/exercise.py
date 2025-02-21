from pydantic import BaseModel
from typing import Optional

class ExerciseBase(BaseModel):
    name: str
    calories_burned_per_minute: Optional[float] = None

class ExerciseCreate(ExerciseBase):
    """Schema for creating a new exercise."""
    pass

class ExerciseUpdate(BaseModel):
    """Schema for updating existing exercise fields."""
    name: Optional[str] = None
    calories_burned_per_minute: Optional[float] = None

class Exercise(ExerciseBase):
    """Schema for reading exercise data (includes DB id)."""
    id: int

    class Config:
        from_attributes = True  # Use this instead of orm_mode
