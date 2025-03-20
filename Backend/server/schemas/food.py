from typing import Optional, Any

from pydantic import BaseModel, Field
from .edamam import EdamamNutritionInfoSchema

class FoodSchema(BaseModel):
    food_id: Optional[int] = Field(None)
    name: str
    serving_size: float
    unit: str

    calories: float
    protein_g: float
    carbs_g: float
    fat_g: float
