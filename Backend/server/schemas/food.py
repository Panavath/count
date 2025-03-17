from typing import Optional, Any

from pydantic import BaseModel
from .edamam import EdamamNutritionInfoSchema

class BaseFoodSchema(BaseModel):
    name: str
    serving_size: float
    unit: str

class FoodWithInfoSchema(BaseFoodSchema):
    calories: float
    protein_g: float
    carbs_g: float
    fat_g: float
