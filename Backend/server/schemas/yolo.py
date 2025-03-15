from typing import Optional

from pydantic import BaseModel

from .edamam import EdamamNutritionInfo


class BaseScannedFood(BaseModel):
    class_name: str
    confidence: float
    bbox: list


class ScannedFoodWithInfo(BaseScannedFood):
    nutrition_info: EdamamNutritionInfo
