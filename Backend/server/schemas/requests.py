from pydantic import BaseModel

from food_log import FoodLogSchema
from user import UserSchema


class NewFoodLogRequestSchema(BaseModel):
    user_id: int
    content: list[FoodLogSchema]


class NewUserRequestSchema(BaseModel):
    user_name: str
