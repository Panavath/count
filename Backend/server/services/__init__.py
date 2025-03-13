from .edamam_service import EdamamService
from .yolo_service import YoloService

__all__ = [
    "ensure_initialized",
    "EdamamService",
    "YoloService",
]

def ensure_initialized():
    if all([EdamamService._instance, YoloService._instance]):
        return
    raise RuntimeError('Services not initialized.')
