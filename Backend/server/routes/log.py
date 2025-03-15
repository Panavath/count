from os import path
import shutil

from fastapi import File, Query, UploadFile, HTTPException
from pydantic import BaseModel

from . import Router
from schemas.yolo import ScannedFoodWithInfo
from schemas.food_log import BaseFoodLog
from services import YoloService, EdamamService, DatabaseService

from other.utils import Log, Path, list_model_to_dict

log_router = Router(prefix='/log', tags=['log'])


@log_router.r.get('')
def get_logs():
    return {'message': ''}


@log_router.r.post('/food/')
def post_log_food(food: BaseFoodLog, user_id: int = Query(...)):
    Log.print_debug(user_id)
    Log.print_debug(food)
    user = DatabaseService.get_user_by_id(user_id)

    if user is None:
        return HTTPException(404, "User not found plz register.")

    new_log = DatabaseService.add_food_log(user_id, food)
    return new_log

@log_router.r.get('/food/')
def get_log_food(user_id: int = Query(...)):
    Log.print_debug(user_id)
    user = DatabaseService.get_user_by_id(user_id)

    if user is None:
        return HTTPException(404, "User not found plz register.")

    logs = DatabaseService.get_log_of_user(user_id)

    if logs is None:
        return {'logs': []}
    print(logs)
    return {'logs': logs[0]._data}


@log_router.r.post('/scan/')
def post_log_scan(file: UploadFile = File(...)):
    detected_foods = YoloService.analyze_image(file.file.read())

    foods: list[ScannedFoodWithInfo] = []
    for food in detected_foods:
        nutri = EdamamService.get_nutrition_info(food)
        foods.append(ScannedFoodWithInfo(**food.model_dump(), nutrition_info=nutri))

    Path.save_cache_json('test.json', list_model_to_dict("foods", detected_foods))

    return {'foods': detected_foods}
