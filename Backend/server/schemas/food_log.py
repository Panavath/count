from datetime import datetime

from pydantic import BaseModel, Field

from enums import MealType
from .food import FoodWithInfoSchema

class BaseFoodLogSchema(BaseModel):
    name: str
    meal_type: MealType
    time: datetime
    foods: list[FoodWithInfoSchema]
