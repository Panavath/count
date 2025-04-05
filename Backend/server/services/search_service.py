from __future__ import annotations

from schemas.edamam import EdamamNutritionInfoSchema
from schemas.yolo import BaseScannedFoodSchema
from repositories.edamam.base import BaseEdamamRepository
from other.utils import Log
from other.exceptions import NoFoodEdamamException
from schemas.food import FoodSchema
from repositories.search.base import BaseSearchRepo


class SearchService:
    _instance: SearchService | None = None
    _search_repository: BaseSearchRepo
    _api_repository: BaseEdamamRepository

    @classmethod
    def get_instance(cls) -> SearchService:
        if cls._instance is None:
            raise RuntimeError('Search service is not initialized.')

        return cls._instance

    @property
    def search_repository(self) -> BaseSearchRepo:
        return self._search_repository

    @property
    def api_repository(self) -> BaseEdamamRepository:
        return self._api_repository

    @classmethod
    def initialize(cls, search_repo: BaseSearchRepo, api_repo: BaseEdamamRepository) -> None:
        Log.print_debug('Search service initialized with repo:',
                        type(search_repo).__name__, type(api_repo).__name__)
        instance = SearchService()
        instance._search_repository = search_repo
        instance._api_repository = api_repo
        cls._instance = instance

    @classmethod
    def search_food(cls, query: str) -> list[EdamamNutritionInfoSchema]:
        cached_search = cls.get_instance().search_repository.search_food(query)

        if cached_search != []:
            Log.print_debug('search cache hit:', query)
            return cached_search

        try:
            api_search = cls.get_instance().api_repository.get_nutrition_info(
                BaseScannedFoodSchema(bbox=[], class_name=query, confidence=0),
            )
            Log.print_debug('Search cache miss:', query)

            return [EdamamNutritionInfoSchema(
                description=query,
                calories=api_search.calories,
                carbs_g=api_search.carbs_g,
                fat_g=api_search.fat_g,
                protein_g=api_search.protein_g,
            )]
        except NoFoodEdamamException:
            return []
