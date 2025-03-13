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

    def get_nutrition_info(self, scanned_food: ScannedFood) -> EdamamNutritionInfo:
        params = {
            "ingr": scanned_food.class_name,
            "app_id": self._app_id,
            "app_key": self._api_key,
            "nutrition-type": "cooking"
        }

        response = self._session.get(
            f"{self._url}{self._nutrition_info_endpoint}",
            params=params
        )

        if response.status_code != 200:
            raise RuntimeError(f"Request failed for '{scanned_food.class_name}' with status code {response.status_code}")

        data = response.json()
        if "hints" not in data or not data["hints"]:
            raise RuntimeError(f"No food items found for '{scanned_food.class_name}'.")

        food_data = data["hints"][0]["food"]
        label = food_data.get("label", "Unknown")
        nutrients = food_data.get("nutrients", {})

        return EdamamNutritionInfo(
            description=label,
            calories=nutrients.get("ENERC_KCAL", "N/A"),
            protein=nutrients.get("PROCNT", "N/A"),
            fat=nutrients.get("FAT", "N/A"),
            carbs=nutrients.get("CHOCDF", "N/A")
        )
