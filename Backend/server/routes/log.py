from os import path
import shutil

from fastapi import File, UploadFile
from pydantic import BaseModel

from . import Router
from services import YoloService, EdamamService

from other.utils import Path, list_model_to_dict

class test(BaseModel):
    name: str

log_router = Router(prefix='/log', tags=['log'])


@log_router.r.get('')
def get_logs():
    return {'message': ''}

@log_router.r.post('/food/')
def log_food(food: test):
    return food


@log_router.r.post('/scan/')
def post_log_scan(file: UploadFile = File(...)):
    detected_foods = YoloService.analyze_image(file.file.read())
    for food in detected_foods:
        nutri = EdamamService.get_nutrition_info(food)
        food.nutrition_info = nutri

    Path.save_cache_json('test.json', list_model_to_dict("foods", detected_foods))

    return {'foods': detected_foods}
