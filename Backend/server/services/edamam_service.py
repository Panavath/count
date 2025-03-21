from __future__ import annotations

from typing import Sequence

from ultralytics import YOLO

from repositories.edamam.base import BaseEdamamRepository
from schemas.edamam import EdamamNutritionInfoSchema
from schemas.yolo import BaseScannedFoodSchema
from other.utils import Log


class EdamamService:
    _instance: EdamamService | None = None
    _repository: BaseEdamamRepository

    @classmethod
    def get_instance(cls) -> EdamamService:
        if cls._instance is None:
            raise RuntimeError('Edamam service is not initialized.')

        return cls._instance

    @property
    def repository(self) -> BaseEdamamRepository:
        return self._repository

    @classmethod
    def initialize(cls, repo: BaseEdamamRepository) -> None:
        Log.print_debug('Edamam service initialized with repo:', type(repo).__name__)
        instance = EdamamService()
        instance._repository = repo
        cls._instance = instance

    @classmethod
    def get_nutrition_info(cls, food: BaseScannedFoodSchema) -> EdamamNutritionInfoSchema:
        """
        Gets the nutrition information for the provided food or list of foods

        Args:
            food (Sequence[ScannedFood]): list of foods

        Returns:
            EdamamNutritionInfo:
        """

        try:
            return cls.get_instance().repository.get_nutrition_info(food)
        except RuntimeError as e:
            raise RuntimeError(f"Failed to fetch nutrition info for '{food.class_name}': {e}")
