from fastapi import FastAPI

from models.user_model import User

app = FastAPI()

@app.get("/")
def read_root(user: User):
    return {"message": f"Hello, {user.name}"}

@app.put("/{user.id}")
def put_user(id: int ,user: User):
    return user.id
    

