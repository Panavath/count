from pydantic import BaseModel, Field
from datetime import datetime

class FoodLogBase(BaseModel):
    user_id: int = Field(..., example=1)
    food_id: int = Field(..., example=1)
    quantity: float = Field(..., example=100.0)
    meal_type: str = Field(..., example="breakfast")

class FoodLogCreate(FoodLogBase):
    pass

class FoodLog(FoodLogBase):
    id: int
    date: datetime

    class Config:
        from_attributes = True  # Use this instead of orm_mode