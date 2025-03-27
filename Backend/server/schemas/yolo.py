from typing import Optional

from pydantic import BaseModel

from .edamam import EdamamNutritionInfoSchema


class BaseScannedFoodSchema(BaseModel):
    class_name: str
    confidence: float
    bbox: list


class ScannedFoodWithInfoSchema(BaseScannedFoodSchema):
    nutrition_info: EdamamNutritionInfoSchema
