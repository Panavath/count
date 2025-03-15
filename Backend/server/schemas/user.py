from typing import Optional
from datetime import datetime

from pydantic import BaseModel

from .food_log import BaseFoodLog

class BaseUser(BaseModel):
    username: str
    food_logs: list[BaseFoodLog]