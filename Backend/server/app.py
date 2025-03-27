import uvicorn
from fastapi import FastAPI

from config import PORT
from routes import load_routes
from services import *
from repositories import *
from database.database import create_tables

app = FastAPI()
EdamamService.initialize(EdamamRepository())
YoloService.initialize("UECFood256.pt")
DatabaseService.initialize(db_repo=BaseDBRepository())
SearchService.initialize(CacheSearchRepo())


@app.get('/')
async def root():
    return {'message': 'Hello World!'}


load_routes(app)

if __name__ == '__main__':
    ensure_initialized()
    create_tables()
    uvicorn.run(app, port=PORT)
