from abc import ABC, abstractmethod

from schemas.food import FoodSchema

class BaseSearchRepo(ABC):
    @abstractmethod
    def search_food(self, query: str) -> list[FoodSchema]:
        ...