from datetime import datetime
from enum import Enum

from pydantic import BaseModel, Field

from .food import FoodWithInfo

class MealType(Enum):
    breakfast = 'Breakfast'
    lunch = 'Lunch'
    dinner = 'Dinner'
    snack = 'Snack'


class BaseFoodLog(BaseModel):
    name: str
    meal_type: MealType
    time: datetime
    foods: list[FoodWithInfo]