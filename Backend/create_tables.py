# create_tables.py
from database.database import Base, engine
from models.users import User
from models.food import Food
from models.food_log import FoodLog
from models.exercise import Exercise
from models.exercise_log import ExerciseLog
from models.goal import Goal
from models.weight import WeightLog

# This line creates all tables defined in your models if they don't exist
Base.metadata.create_all(bind=engine)

print("Database tables created!")
