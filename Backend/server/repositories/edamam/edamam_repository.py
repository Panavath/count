from requests import Session

from repositories.edamam.base import BaseEdamamRepository
from schemas.edamam import EdamamNutritionInfo
from schemas.food import ScannedFood


class EdamamRepository(BaseEdamamRepository):
    _session: Session
    
    def __init__(self) -> None:
        self._session = Session()
    
    def get_nutrition_info(self, scanned_food: ScannedFood) -> list[EdamamNutritionInfo]:
        """
        Get the nutrition informations of the scanned food from the Edamam API.
        
        Args:
            scanned_food (ScannedFood): data from the scanned food
            
        Returns:
            list[EdamamNutritionInfo]: ...
        """
        ... # TODO: DS team