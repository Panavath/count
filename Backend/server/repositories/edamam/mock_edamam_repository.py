from requests import Session

from repositories.edamam.base import BaseEdamamRepository
from schemas.edamam import EdamamNutritionInfo
from schemas.yolo import BaseScannedFood


class MockEdamamRepository(BaseEdamamRepository):
    _session: Session

    def __init__(self) -> None:
        self._session = Session()

    def get_nutrition_info(
        self, scanned_food: BaseScannedFood
    ) -> EdamamNutritionInfo:
        """
        Returns a mock data

        Args:
            scanned_food (ScannedFood): data from the scanned food

        Returns:
            list[EdamamNutritionInfo]: Mock data
        """
        return EdamamNutritionInfo(
            description="idk",
            calories=180.0,
            protein=100.0,
            fat=30.0,
            carbs=100.0,
        )
