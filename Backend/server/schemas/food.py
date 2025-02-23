from typing import Optional

from pydantic import BaseModel

class BaseFood(BaseModel):
    name: str
    amount: float
    unit: str
