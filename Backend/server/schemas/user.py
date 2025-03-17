from typing import Optional
from datetime import datetime

from pydantic import BaseModel

from .food_log import BaseFoodLogSchema

class BaseUserSchema(BaseModel):
    user_name: str
    food_logs: list[BaseFoodLogSchema]
