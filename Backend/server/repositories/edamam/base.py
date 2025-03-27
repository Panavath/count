from abc import ABC, abstractmethod

from schemas.edamam import EdamamNutritionInfoSchema
from schemas.yolo import BaseScannedFoodSchema

class BaseEdamamRepository(ABC):
    @abstractmethod
    def get_nutrition_info(self, scanned_food: BaseScannedFoodSchema) -> EdamamNutritionInfoSchema:
        ...
