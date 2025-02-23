import uvicorn
from fastapi import FastAPI

from routes import load_routes

app = FastAPI()



@app.get('/')
def root():
    return {'message': 'Hello World!'}


load_routes(app)

if __name__ == '__main__':
    uvicorn.run(app, port=727)
