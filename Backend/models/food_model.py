from pydantic import BaseModel, Field


class Food(BaseModel):
    id: int = Field(...)
    name: str = Field(...)
    measurement_in: measurement_in = Field(...)
    height: float = Field(...)
    target_calory: float = Field(...)