import uvicorn
from fastapi import FastAPI

from config import PORT
from routes import load_routes
from services import *
from repositories import *

app = FastAPI()
EdamamService.initialize(MockEdamamRepository())
YoloService.initialize("yolov8n.pt")


@app.get('/')
def root():
    return {'message': 'Hello World!'}


load_routes(app)

if __name__ == '__main__':
    ensure_initialized()
    uvicorn.run(app, port=PORT)
