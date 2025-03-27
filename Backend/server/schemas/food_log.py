from datetime import datetime
from typing import Optional

from pydantic import BaseModel, Field

from enums import MealType
from .food import FoodSchema


class FoodLogSchema(BaseModel):
    food_log_id: int
    name: str
    meal_type: MealType
    date: datetime
    foods: list[FoodSchema]


class FoodLogCreationSchema(FoodLogSchema):
    food_log_id: int | None = None
