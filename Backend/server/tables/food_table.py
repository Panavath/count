from typing import TYPE_CHECKING

from sqlalchemy import ForeignKey, Integer, String
from sqlalchemy.orm import relationship, Mapped, mapped_column

from database import BaseTable
from enums import MealType

if TYPE_CHECKING:
    from .food_log_table import FoodLogTable


class FoodTable(BaseTable):
    __tablename__ = 'Food'

    # Columns
    food_id: Mapped[int] = mapped_column(
        primary_key=True, index=True, autoincrement=True)
    food_log_id: Mapped[int] = mapped_column(ForeignKey('FoodLog.food_log_id'))
    name: Mapped[str] = mapped_column(nullable=False)
    serving_size: Mapped[float] = mapped_column(nullable=False)
    unit: Mapped[str] = mapped_column(nullable=False)

    value_calculated: Mapped[bool] = mapped_column(default=False)
    calories: Mapped[float] = mapped_column(default=0.0)
    protein_g: Mapped[float] = mapped_column(default=0.0)
    carbs_g: Mapped[float] = mapped_column(default=0.0)
    fat_g: Mapped[float] = mapped_column(default=0.0)

    # Relationships
    food_log: Mapped['FoodLogTable'] = relationship(
        'FoodTable', uselist=True, back_populates='foods')

    def __init__(
            self, *,
            name: str,
            serving_size: float,
            unit: str,
            values_calculated: bool,
            calories: float = 0,
            protein_g: float = 0,
            carbs_g: float = 0,
            fat_g: float = 0,
            **kwargs,
    ):
        super().__init__(
            name=name, serving_size=serving_size, unit=unit, values_calculated=values_calculated,
            calories=calories, protein_g=protein_g, carbs_g=carbs_g, fat_g=fat_g, **kwargs
        )

    def __repr__(self) -> str:
        return f'Food(name={self.name}, serving size={self.serving_size}{self.unit}, calory={self.calories})'
