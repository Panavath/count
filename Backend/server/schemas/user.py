from typing import Optional
from datetime import datetime

from pydantic import BaseModel

from .food_log import FoodLogSchema

class UserSchema(BaseModel):
    user_id: Optional[int]
    user_name: str
    food_logs: list[FoodLogSchema]
