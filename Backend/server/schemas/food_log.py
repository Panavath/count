from datetime import datetime

from pydantic import BaseModel, Field

from enums.enums import MealType
from .food import FoodWithInfo

class BaseFoodLog(BaseModel):
    name: str
    meal_type: MealType
    time: datetime
    foods: list[FoodWithInfo]
