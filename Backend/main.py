from fastapi import FastAPI

from models.user_model import User

app = FastAPI()

@app.get("/")
def read_root(user: User):
    return {"message": f"Hello, {user.name}"}
