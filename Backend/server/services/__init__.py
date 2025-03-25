from .edamam_service import EdamamService
from .yolo_service import YoloService
from .database_service import DatabaseService
from .search_service import SearchService

__all__ = [
    'ensure_initialized',
    'EdamamService',
    'YoloService',
    'DatabaseService',
    'SearchService',
]


def ensure_initialized():
    if all(
        [
            EdamamService._instance,
            YoloService._instance,
            DatabaseService._instance,
            SearchService._instance,
        ]
    ):
        return
    raise RuntimeError('Services not initialized.')
