from typing import Optional, Any

from pydantic import BaseModel

class BaseFood(BaseModel):
    name: str
    amount: float
    unit: str


class ScannedFood(BaseModel):
    class_name: str
    confidence: float
    bbox: Any  # change to its type