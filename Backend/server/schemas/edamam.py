from pydantic import BaseModel


class EdamamNutritionInfo(BaseModel):
    # Not sure about the types
    description: str
    calories: float
    protein: float
    fat: float
    carbohydrates: float