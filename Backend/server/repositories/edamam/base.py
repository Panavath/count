from abc import ABC, abstractmethod

from schemas.edamam import EdamamNutritionInfo
from schemas.yolo import BaseScannedFood

class BaseEdamamRepository(ABC):
    @abstractmethod
    def get_nutrition_info(self, scanned_food: BaseScannedFood) -> EdamamNutritionInfo:
        ...
