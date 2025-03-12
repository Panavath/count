from __future__ import annotations

from typing import Sequence

from ultralytics import YOLO

from repositories.edamam.base import BaseEdamamRepository
from schemas.edamam import EdamamNutritionInfo
from schemas.food import ScannedFood


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
        instance = EdamamService()
        instance._repository = repo
        cls._instance = instance

    @classmethod
    def get_nutrition_info(cls, food: ScannedFood | Sequence[ScannedFood]) -> list[EdamamNutritionInfo]:
        """
        Gets the nutrition informations for the provided food or list of foods

        Args:
            food (ScannedFood | Sequence[ScannedFood]): list of foods

        Returns:
            list[EdamamNutritionInfo]: might be incorrect plz chek
        """
        ...  # TODO: DS team
