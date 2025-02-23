from sqlalchemy import Column, Integer, String, Float, ForeignKey, Boolean
from database.database import BaseModel


class FoodModel(BaseModel):
    __tablename__ = "Food"

    # Columns
    food_id = Column(Integer, primary_key=True, index=True)
    food_log_id = Column(
        Integer,
        ForeignKey('FoodLog.food_log_id'),
        nullable=False
    )
    name = Column(String, nullable=False)
    quantity = Column(Float)
    unit = Column(String)

    values_calculated = Column(Boolean, default=False)
    calories = Column(Float, default=0.0)
    protein_g = Column(Float, default=0.0)
    carbs_g = Column(Float, default=0.0)
    fat_g = Column(Float, default=0.0)
    serving_size_g = Column(Float, default=0.0)
