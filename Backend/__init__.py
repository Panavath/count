# create_tables.py (example script at project root)
from database.database import Base, engine
from models.users import User
from models.food import Food
from models.food_log import FoodLog
from models.exercise import Exercise
from models.exercise_log import ExerciseLog
from models.goal import Goal
from models.weight import WeightLog

# This line will create all the tables if they don't exist
Base.metadata.create_all(bind=engine)
