from abc import ABC, abstractmethod

from schemas.edamam import EdamamNutritionInfo
from schemas.food import ScannedFood

class BaseEdamamRepository(ABC):
    @abstractmethod
    def get_nutrition_info(self, scanned_food: ScannedFood) -> list[EdamamNutritionInfo]:
        ...