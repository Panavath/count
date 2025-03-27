import json
import atexit
from typing import Any

from requests import Session
from config import EDAMAM_API_KEY, EDAMAM_APP_ID

from database import SessionLocal
from repositories.edamam.base import BaseEdamamRepository
from schemas.edamam import EdamamNutritionInfoSchema
from schemas.yolo import BaseScannedFoodSchema
from tables import EdamamCacheTable

from other.utils import Log


class EdamamRepository(BaseEdamamRepository):
    session: Session
    _api_key: str
    _app_id: str

    _url = 'https://api.edamam.com/'
    _nutrition_info_endpoint = 'api/food-database/v2/parser'

    def __init__(self) -> None:
        self.db_session = SessionLocal()
        atexit.register(lambda: self.db_session.close())
        self.session = Session()
        self._api_key = EDAMAM_API_KEY
        self._app_id = EDAMAM_APP_ID

    def get_nutrition_info_api(self, ingr: str) -> dict[str, Any]:
        cache = self.db_session.query(EdamamCacheTable).where(EdamamCacheTable.key == ingr).first()
        if cache is not None:
            Log.print_debug('Cache hit for ingredient', ingr)
            return json.loads(cache.value)
        params = {
            'ingr': ingr,
            'app_id': self._app_id,
            'app_key': self._api_key,
            'nutrition-type': 'cooking',
        }

        response = self.session.get(
            f"{self._url}{self._nutrition_info_endpoint}", params=params
        )

        if response.status_code != 200:
            raise RuntimeError(
                f"Request failed for '{ingr}' with status code {response.status_code}"
            )

        data = response.content.decode()
        if "hints" not in data:
            raise RuntimeError(f"No food items found for '{ingr}'.")
        new_cache = EdamamCacheTable(key=ingr, value=data)
        self.db_session.add(new_cache)
        self.db_session.commit()
        self.db_session.refresh(new_cache)
        return json.loads(data)

    def get_nutrition_info(self, scanned_food: BaseScannedFoodSchema) -> EdamamNutritionInfoSchema:
        data = self.get_nutrition_info_api(scanned_food.class_name)

        food_data = data["hints"][0]["food"]
        label = food_data.get("label", "Unknown")
        nutrients = food_data.get("nutrients", {})

        return EdamamNutritionInfoSchema(
            description=label,
            calories=nutrients.get("ENERC_KCAL", "N/A"),
            protein_g=nutrients.get("PROCNT", "N/A"),
            carbs_g=nutrients.get("CHOCDF", "N/A"),
            fat_g=nutrients.get("FAT", "N/A"),
        )
