from __future__ import annotations

from dataclasses import dataclass

from schemas import *
from tables import *


class UserDTO:
    @staticmethod
    def from_table_to_schema(data: UserTable) -> UserSchema:
        logs: list[FoodLogSchema] = []
        for food_log_table in data.food_logs:
            logs.append(FoodLogDTO.from_table_to_schema(food_log_table))

        return UserSchema(
            user_id=data.user_id,
            user_name=data.user_name,
            food_logs=logs
        )


class FoodLogDTO:
    @staticmethod
    def from_table_to_schema(data: FoodLogTable) -> FoodLogSchema:
        foods: list[FoodSchema] = []
        for food_table in data.foods:
            foods.append(FoodDTO.from_table_to_schema(food_table))

        return FoodLogSchema(
            food_log_id=data.food_log_id,
            name=data.name,
            meal_type=data.meal_type,
            date=data.date,
            foods=foods,
        )

    @staticmethod
    def from_schema_to_table(data: FoodLogSchema) -> FoodLogTable:
        foods: list[FoodTable] = []

        for food in data.foods:
            foods.append(FoodDTO.from_schema_to_table(food))

        return FoodLogTable(
            food_log_id=data.food_log_id,
            name=data.name,
            meal_type=data.meal_type,
            date=data.date,
            foods=foods,
        )



@dataclass
class FoodDTO:
    name: str
    serving_size: float
    unit: str

    values_calculated: bool

    description: str
    calories: float
    protein_g: float
    fat_g: float
    carbs_g: float

    def to_table(self) -> FoodTable:
        return FoodTable(
            name=self.name,
            serving_size=self.serving_size,
            unit=self.unit,
            values_calculated=self.values_calculated,
            calories=self.calories,
            protein_g=self.protein_g,
            carbs_g=self.carbs_g,
            fat_g=self.fat_g,
        )

    @staticmethod
    def from_table_to_schema(data: FoodTable) -> FoodSchema:
        return FoodSchema(
            food_id=data.food_id,
            name=data.name,
            serving_size=data.serving_size,
            unit=data.unit,
            calories=data.calories,
            protein_g=data.protein_g,
            carbs_g=data.carbs_g,
            fat_g=data.fat_g,
        )

    @staticmethod
    def from_schema_to_table(data: FoodSchema) -> FoodTable:
        values_calculated = False

        if any([
            data.calories > 0,
            data.protein_g > 0,
            data.carbs_g > 0,
            data.fat_g > 0,
            ]):
            values_calculated = True

        return FoodTable(
            food_id=data.food_id,
            name=data.name,
            serving_size=data.serving_size,
            values_calculated=values_calculated,
            unit=data.unit,
            calories=data.calories,
            protein_g=data.protein_g,
            carbs_g=data.carbs_g,
            fat_g=data.fat_g,
        )


__all__ = [
    'UserDTO',
    'FoodDTO',
    'FoodDTO',
]
