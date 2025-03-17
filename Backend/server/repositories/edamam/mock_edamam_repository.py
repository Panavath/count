from requests import Session

from repositories.edamam.base import BaseEdamamRepository
from schemas.edamam import EdamamNutritionInfoSchema
from schemas.yolo import BaseScannedFoodSchema


class MockEdamamRepository(BaseEdamamRepository):
    _session: Session

    def __init__(self) -> None:
        self._session = Session()

    def get_nutrition_info(
        self, scanned_food: BaseScannedFoodSchema
    ) -> EdamamNutritionInfoSchema:
        """
        Returns a mock data

        Args:
            scanned_food (ScannedFood): data from the scanned food

        Returns:
            list[EdamamNutritionInfo]: Mock data
        """
        return EdamamNutritionInfoSchema(
            description="idk",
            calories=180.0,
            protein_g=100.0,
            fat_g=30.0,
            carbs_g=100.0,
        )
