from __future__ import annotations

from ultralytics import YOLO

from schemas.food import ScannedFood

class YoloService:
    _instance: YoloService
    model: YOLO

    @classmethod
    def get_instance(cls) -> YoloService:
        if cls._instance is None:
            raise RuntimeError('YOLO service is not initialized.')

        return cls._instance

    @classmethod
    def initialize(cls, model: YOLO) -> None:
        instance = YoloService()
        instance.model = model
        cls._instance = instance

    @classmethod
    def analyze_image(cls, file_content: bytes) -> list[ScannedFood]:
        """
        Analyze the file content for foods.

        Args:
            file_content (bytes): the image data in bytes

        Returns:
            list[ScannedFood]: the list of detected food informations
        """
        ... # TODO: DS team
