from typing import Optional, Any

from pydantic import BaseModel
from .edamam import EdamamNutritionInfo

class BaseFood(BaseModel):
    name: str
    amount: float
    unit: str

class FoodWithInfo(BaseFood):
    nutrition_info: EdamamNutritionInfo
