from __future__ import annotations

from other.utils import Log
from schemas.food import FoodSchema
from repositories.search.base import BaseSearchRepo

class SearchService:
    _instance: SearchService | None = None
    _repository: BaseSearchRepo

    @classmethod
    def get_instance(cls) -> SearchService:
        if cls._instance is None:
            raise RuntimeError('Search service is not initialized.')

        return cls._instance

    @property
    def repository(self) -> BaseSearchRepo: 
        return self._repository
    
    @classmethod
    def initialize(cls, repo: BaseSearchRepo) -> None:
        Log.print_debug('Search service initialized with repo:', type(repo).__name__)
        instance = SearchService()
        instance._repository = repo
        cls._instance = instance
        
    @classmethod
    def search_food(cls, query: str) -> list[FoodSchema]:
        return cls.get_instance().repository.search_food(query)
        