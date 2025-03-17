import uvicorn
from fastapi import FastAPI

from config import PORT
from routes import load_routes
from services import *
from repositories import *
from database.database import create_tables
from database import seed_all

app = FastAPI()
EdamamService.initialize(MockEdamamRepository())
YoloService.initialize("yolov8n.pt")
DatabaseService.initialize(user_db_repo=UserRepository(), food_log_repo=LogRepository())


@app.get('/')
def root():
    return {'message': 'Hello World!'}


load_routes(app)

if __name__ == '__main__':
    ensure_initialized()
    create_tables()
    seed_all()
    uvicorn.run(app, port=PORT)
