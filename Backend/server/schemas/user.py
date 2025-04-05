from typing import Optional, Literal
from datetime import datetime

from pydantic import BaseModel, PositiveFloat

from .food_log import FoodLogSchema
from .other_log import WeightLogSchema, HeightLogSchema

class UserSchema(BaseModel):
    user_id: Optional[int]
    user_name: str
    dob: datetime
    gender: str
    # country: str
    # """`ISO 3166` 2 characters country code."""
    height: float
    weight: float
    register_date: datetime

    height_goal: Optional[float]
    weight_goal: Optional[float]
    calory_goal: Optional[float]

    height_logs: list[HeightLogSchema]
    weight_logs: list[WeightLogSchema]
    food_logs: list[FoodLogSchema]

class UserCreationSchema(BaseModel):
    user_name: str
    dob: datetime
    gender: Literal['male', 'female']
    height: PositiveFloat
    weight: PositiveFloat

    height_goal: Optional[float]
    weight_goal: Optional[float]
    calory_goal: Optional[float]
