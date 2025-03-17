from enum import Enum

__all__ = [
    'MealType',
    # 'WeightGoals',
    # 'MuscleGoals',
    # 'ExerciseType',
]

class WeightGoals(Enum):
    lose_weight = 'Lose Weight'
    gain_weight = 'Gain Weight'
    maintain_weight = 'Maintain Weight'


class MuscleGoals(Enum):
    gain_muscle = 'Gain Muscle'
    maintain_muscle = 'Maintain Muscle'


class MealType(Enum):
    breakfast = 'Breakfast'
    lunch = 'Lunch'
    dinner = 'Dinner'
    snack = 'Snack'

class ExerciseType(Enum):
    weight_lifting = 'Weight Lifting'
    walking = 'Walking'
    running = 'Running'
    cycling = 'Cycling'
    Swimming = 'Swimming'
