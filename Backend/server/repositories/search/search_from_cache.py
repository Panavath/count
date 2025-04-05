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

    def update_cache(self) -> None:
        cached_data = self.session.query(EdamamCacheTable).all()
        self._cache.clear()

        for data_table in cached_data:
            cache = json.loads(data_table.value).get('hints', None)
            if cache:
                for food in cache:
                    food_data: dict[str, Any] = food[
                        'food'
                    ]
                    label: str = food_data.get('label', 'unknown')
                    nutrients = food_data.get("nutrients", {})

                    self._cache.append(
                        EdamamNutritionInfoSchema(
                            description=label,
                            calories=round(nutrients.get("ENERC_KCAL", 0.0), 2),
                            protein_g=round(nutrients.get("PROCNT", 0.0), 2),
                            carbs_g=round(nutrients.get("CHOCDF", 0.0), 2),
                            fat_g=round(nutrients.get("FAT", 0.0), 2),
                        )
                    )


    def search_food(self, query: str) -> list[EdamamNutritionInfoSchema]:
        self.update_cache()
        found_foods: list[EdamamNutritionInfoSchema] = []

        query = query.lower()
        for food in self._cache:
            if query in food.description.lower():
                found_foods.append(food)

        return found_foods
