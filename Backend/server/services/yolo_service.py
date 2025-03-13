from __future__ import annotations

from ultralytics import YOLO
import cv2
import numpy as np

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
        np_img = np.frombuffer(file_content, np.uint8)
        img = cv2.imdecode(np_img, cv2.IMREAD_COLOR)

        if img is None:
            raise RuntimeError("Failed to decode the image.")

        results = cls._instance.model(img)
        result = results[0]

        detected_foods = []
        for box in result.boxes:
            bbox = box.xyxy[0].tolist()  # Bounding box coordinates (x1, y1, x2, y2)
            conf = box.conf.item()
            class_id = int(box.cls.item())
            class_name = cls._instance.model.names[class_id]

            food = ScannedFood(name=class_name, confidence=conf, bbox=bbox)
            detected_foods.append(food)

        if not detected_foods:
            raise RuntimeError("No food items detected in the image.")

        return detected_foods
