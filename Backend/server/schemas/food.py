from typing import Optional, Any

from pydantic import BaseModel
from .edamam import EdamamNutritionInfo

class BaseFood(BaseModel):
    name: str
    amount: float
    unit: str


class ScannedFood(BaseModel):
    class_name: str
    confidence: float
    bbox: list
    nutrition_info: Optional[EdamamNutritionInfo]
