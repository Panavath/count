from __future__ import annotations

from ultralytics import YOLO
import cv2
import numpy as np

from schemas.food import ScannedFood
from other.utils import Path, Log

class YoloService:
    _instance: YoloService | None = None
    model: YOLO

    @classmethod
    def get_instance(cls) -> YoloService:
        if cls._instance is None:
            raise RuntimeError('YOLO service is not initialized.')

        return cls._instance

    @classmethod
    def initialize(cls, model_name: str) -> None:
        Log.print_debug('YOLO service initialized with model:', model_name)
        instance = YoloService()
        instance.model = YOLO(Path.YOLO_MODEL_DIR / model_name)
        cls._instance = instance

    @classmethod
    def analyze_image(cls, file_content: bytes) -> list[ScannedFood]:
        """
        Analyze the file content for foods.

        Args:
            file_content (bytes): the image data in bytes

        Returns:
            list[ScannedFood]: the list of detected food information
        """
        np_img = np.frombuffer(file_content, np.uint8)
        img = cv2.imdecode(np_img, cv2.IMREAD_COLOR)

        if img is None:
            raise RuntimeError("Failed to decode the image.")

        results = cls.get_instance().model(img)

        detected_foods = []

        for result in results:
            for box in result.boxes:
                bbox = box.xyxy[0].tolist()  # Bounding box coordinates (x1, y1, x2, y2)
                conf = box.conf.item()
                class_id = int(box.cls.item())
                class_name = cls.get_instance().model.names[class_id]

                food = ScannedFood(class_name=class_name, confidence=conf, bbox=bbox, nutrition_info=None)
                detected_foods.append(food)

            if not detected_foods:
                raise RuntimeError("No food items detected in the image.")

        return detected_foods
