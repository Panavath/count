from pydantic import BaseModel
from typing import Optional

class GoalBase(BaseModel):
    user_id: int
    target_weight_kg: Optional[float] = None
    daily_calories_goal: Optional[float] = None
    protein_goal_g: Optional[float] = None
    carbs_goal_g: Optional[float] = None
    fat_goal_g: Optional[float] = None

class GoalCreate(GoalBase):
    """Schema for creating a new goal."""
    pass

class GoalUpdate(BaseModel):
    """Schema for updating existing goal fields."""
    target_weight_kg: Optional[float] = None
    daily_calories_goal: Optional[float] = None
    protein_goal_g: Optional[float] = None
    carbs_goal_g: Optional[float] = None
    fat_goal_g: Optional[float] = None

class Goal(GoalBase):
    """Schema for reading goal data (includes DB id)."""
    id: int

    class Config:
        from_attributes = True  # Use this instead of orm_mode
