from requests import Session

from repositories.edamam.base import BaseEdamamRepository
from schemas.edamam import EdamamNutritionInfo
from schemas.food import ScannedFood


class MockEdamamRepository(BaseEdamamRepository):
    _session: Session

    def __init__(self) -> None:
        self._session = Session()

    def get_nutrition_info(
        self, scanned_food: ScannedFood
    ) -> list[EdamamNutritionInfo]:
        """
        Returns a mock data

        Args:
            scanned_food (ScannedFood): data from the scanned food

        Returns:
            list[EdamamNutritionInfo]: Mock data
        """
        return [
            EdamamNutritionInfo(
                description="idk",
                calories=180.0,
                protein=100.0,
                fat=30.0,
                carbohydrates=100.0,
            )
        ]
