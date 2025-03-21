from pydantic import BaseModel


class EdamamNutritionInfoSchema(BaseModel):
    description: str
    calories: float
    protein_g: float
    carbs_g: float
    fat_g: float
