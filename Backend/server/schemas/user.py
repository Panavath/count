from typing import Optional
from datetime import datetime

from pydantic import BaseModel

class BaseUser(BaseModel):
    username: str
