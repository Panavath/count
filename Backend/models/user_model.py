from pydantic import BaseModel, Field


class User(BaseModel):
    id: int = Field(...)
    name: str = Field(...)
    weight: float = Field(...)
    height: float = Field(...)
    target_calory: float = Field(...)