import json
from typing import Any

from database import SessionLocal
from repositories.search.base import BaseSearchRepo
from schemas.edamam import EdamamNutritionInfoSchema
from schemas.food import FoodSchema
from tables.edamam_cache_table import EdamamCacheTable


class CacheSearchRepo(BaseSearchRepo):

    _cache: list[EdamamNutritionInfoSchema]

    def __init__(self) -> None:
        self.session = SessionLocal()
        self._cache = []
        self.update_cache()

    def update_cache(self) -> None:
        cached_data = self.session.query(EdamamCacheTable).all()
        self._cache.clear()

        for data_table in cached_data:
            food_data: dict[str, Any] = json.loads(data_table.value)['hints'][0][
                'food'
            ]
            label: str = food_data.get('label', 'unknown')
            nutrients = food_data.get("nutrients", {})

            self._cache.append(
                EdamamNutritionInfoSchema(
                    description=label,
                    calories=nutrients.get("ENERC_KCAL", "N/A"),
                    protein_g=nutrients.get("PROCNT", "N/A"),
                    carbs_g=nutrients.get("CHOCDF", "N/A"),
                    fat_g=nutrients.get("FAT", "N/A"),
                )
            )

    def search_food(self, query: str) -> list[EdamamNutritionInfoSchema]:
        self.update_cache()
        found_foods = []

        query = query.lower()
        for food in self._cache:
            if query in food.description.lower():
                found_foods.append(food)
                
        return found_foods
