from pydantic import BaseModel
from typing import Optional

class FoodBase(BaseModel):
    name: str
    calories: Optional[float] = None
    protein_g: Optional[float] = None
    carbs_g: Optional[float] = None
    fat_g: Optional[float] = None
    serving_size_g: Optional[float] = None

class FoodCreate(FoodBase):
    """Schema for creating a new food entry."""
    pass

class FoodUpdate(BaseModel):
    """Schema for updating existing food fields."""
    name: Optional[str] = None
    calories: Optional[float] = None
    protein_g: Optional[float] = None
    carbs_g: Optional[float] = None
    fat_g: Optional[float] = None
    serving_size_g: Optional[float] = None

class Food(FoodBase):
    """Schema for reading food data (includes DB id)."""
    id: int

    class Config:
        from_attributes = True  # Use this instead of orm_mode
