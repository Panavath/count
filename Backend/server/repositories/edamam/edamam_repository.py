from requests import Session
from config import EDAMAM_API_KEY, EDAMAM_APP_ID

from repositories.edamam.base import BaseEdamamRepository
from schemas.edamam import EdamamNutritionInfo
from schemas.food import ScannedFood


class EdamamRepository(BaseEdamamRepository):
    _session: Session
    _api_key: str
    _app_id: str

    _url = 'https://api.edamam.com/'
    _nutrition_info_endpoint = 'api/food-database/v2/parser'

    def __init__(self) -> None:
        self._session = Session()
        self._api_key = EDAMAM_API_KEY
        self._app_id = EDAMAM_APP_ID

    def get_nutrition_info(self, scanned_food: ScannedFood) -> list[EdamamNutritionInfo]:
        """
        Get the nutrition informations of the scanned food from the Edamam API.
        
        Args:
            scanned_food (ScannedFood): data from the scanned food
            
        Returns:
            list[EdamamNutritionInfo]: ...
        """
        ... # TODO: DS team
