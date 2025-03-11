from os import path
import shutil

from fastapi import File, UploadFile
from pydantic import BaseModel

from . import Router

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
    filename = "temp.jpg"
    save_path = path.join('cache', filename)

    with open(save_path, 'wb') as f:
        shutil.copyfileobj(file.file, f)

    return {'filename': filename, "content_type": file.content_type, "file_path": save_path}
