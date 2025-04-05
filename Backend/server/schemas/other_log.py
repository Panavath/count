from datetime import datetime
from typing import Optional

from pydantic import BaseModel, Field

from enums import MealType
from .food import FoodSchema


class WeightLogSchema(BaseModel):
    weight: float
    date: datetime

class HeightLogSchema(BaseModel):
    height: float
    date: datetime
