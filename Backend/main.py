from fastapi import FastAPI

from routes import *
app = FastAPI(title="My Backend API")

# Include your routes
app.include_router(userRouter, prefix="", tags=["users"])

@app.get("/")
def read_root():
    return {"message": "Hello, world!"}
