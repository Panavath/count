# routes/user.py
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from database.database import SessionLocal
from models.users import User as UserModel
from schemas.users import UserCreate, User

userRouter = APIRouter()

# Dependency to get DB session
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()  
from typing import List
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from models.users import User as UserModel
from schemas.users import User, UserCreate
from database.database import SessionLocal

userRouter = APIRouter()

# Dependency to get DB session
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@userRouter.post("/users/", response_model=User)
def create_user(user_data: UserCreate, db: Session = Depends(get_db)):
    # Check if username or email already exists
    existing_user = db.query(UserModel).filter(UserModel.email == user_data.email).first()
    if existing_user:
        raise HTTPException(status_code=400, detail="Email already registered")
    
    # Convert schema to a model
    db_user = UserModel(
        username=user_data.username,
        email=user_data.email,
        hashed_password="some_hash_function(user_data.password)",
        age=user_data.age,
        gender=user_data.gender,
        height_cm=user_data.height_cm,
        weight_kg=user_data.weight_kg
    )
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    
    return db_user

@userRouter.get("/users/", response_model=List[User])
def get_all_users(db: Session = Depends(get_db)):
    """
    Get a list of all users.
    """
    users = db.query(UserModel).all()
    return users

@userRouter.get("/users/{user_id}", response_model=User)
def get_user(user_id: int, db: Session = Depends(get_db)):
    """
    Get a single user by their ID.
    """
    user = db.query(UserModel).filter(UserModel.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user
