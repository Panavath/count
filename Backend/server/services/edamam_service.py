from __future__ import annotations

import os
from config import EDAMAM_API_KEY, EDAMAM_APP_ID
from json import requests

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
    def get_nutrition_info(cls, foods: ScannedFood | Sequence[ScannedFood]) -> list[EdamamNutritionInfo]:
        if isinstance(foods, ScannedFood):
            foods = [foods]

        nutrition_info_list = []
        for food in foods:
            try:
                nutrition_info = cls._instance.repository.get_nutrition_info(food)
                nutrition_info_list.append(nutrition_info)
            except RuntimeError as e:
                raise RuntimeError(f"Failed to fetch nutrition info for '{food.name}': {e}")

        return nutrition_info_list

                
