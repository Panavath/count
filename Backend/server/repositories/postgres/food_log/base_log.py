from abc import ABC, abstractmethod
from datetime import datetime
from typing import Sequence, Any
from enums.enums import MealType
from models import FoodLogModel
from repositories.postgres.base import BaseDBRepository
from schemas.food_log import BaseFoodLog


class BaseFoodLogRepository(BaseDBRepository[FoodLogModel, BaseFoodLog], ABC):
    @abstractmethod
    def create(
        self, *,
        user_id: int,
        meal_type: MealType,
        time: datetime,
        foods: list[Any],
        **kwargs
    ) -> FoodLogModel: ...

    @abstractmethod
    def get_all(self) -> Sequence[FoodLogModel]: ...

    @abstractmethod
    def get_by_id(self, obj_id: int) -> FoodLogModel | None: ...

    @abstractmethod
    def update(self, obj_id: int, **kwargs) -> FoodLogModel | None: ...

    @abstractmethod
    def filter_by(self, **filters) -> Sequence[FoodLogModel]: ...

    @abstractmethod
    def delete(self, obj_id: int) -> bool: ...
