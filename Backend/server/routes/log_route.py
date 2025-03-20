from fastapi import File, Query, UploadFile, HTTPException

from . import CountRouter
from schemas.yolo import ScannedFoodWithInfoSchema
from schemas.food_log import FoodLogCreationSchema
from services import YoloService, EdamamService, DatabaseService

from other.utils import Log, Path, list_model_to_dict
from other.exceptions import NoFoodDetectedException

log_router = CountRouter(prefix='/log', tags=['log'])

@log_router.post('/food/')
async def post_log_food(food: FoodLogCreationSchema, user_id: int = Query(...)):
    Log.print_debug(user_id)
    Log.print_debug(food)
    user = DatabaseService.get_user_by_id(user_id)

    if user is None:
        raise HTTPException(404, "User not found plz register.")

    new_log = DatabaseService.add_food_log(user_id, food)
    return new_log


@log_router.post('/scan/')
async def post_log_scan(file: UploadFile = File(...)):
    try:
        detected_foods = YoloService.analyze_image(file.file.read())
    except NoFoodDetectedException as e:
        raise HTTPException(422, e.args[0])


    foods: list[ScannedFoodWithInfoSchema] = []
    for food in detected_foods:
        nutri = EdamamService.get_nutrition_info(food)
        foods.append(ScannedFoodWithInfoSchema(**food.model_dump(), nutrition_info=nutri))

    Path.save_cache_json('test.json', list_model_to_dict("foods", detected_foods))

    return {'foods': foods}
