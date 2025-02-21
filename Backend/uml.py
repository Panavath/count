from graphviz import Digraph

def add_class(uml, class_name, attributes):
    """Helper function to add a class node."""
    label = f"{class_name}\n-----------------\n" + "\n".join(attributes)
    uml.node(class_name, label)

# Create UML diagram with improved styling
uml = Digraph('UML_Diagram', filename='myfitnesspal_uml', format='png')
uml.graph_attr.update(rankdir="LR", splines="ortho")
uml.node_attr.update(shape="record", fontname="Helvetica")
uml.edge_attr.update(fontname="Helvetica", fontsize="10")

# Define classes using the helper function
add_class(uml, 'User', [
    "+ id: Integer (PK)",
    "+ username: String",
    "+ email: String",
    "+ hashed_password: String",
    "+ age: Integer",
    "+ gender: String",
    "+ height_cm: Float",
    "+ weight_kg: Float",
    "-----------------",
    "+ food_entries: List[FoodLog]",
    "+ exercise_entries: List[ExerciseLog]"
])

add_class(uml, 'Food', [
    "+ id: Integer (PK)",
    "+ name: String",
    "+ calories: Float",
    "+ protein_g: Float",
    "+ carbs_g: Float",
    "+ fat_g: Float",
    "+ serving_size_g: Float"
])

add_class(uml, 'FoodLog', [
    "+ id: Integer (PK)",
    "+ user_id: Integer (FK)",
    "+ food_id: Integer (FK)",
    "+ quantity: Float",
    "+ meal_type: String",
    "+ date: DateTime"
])

add_class(uml, 'Exercise', [
    "+ id: Integer (PK)",
    "+ name: String",
    "+ calories_burned_per_minute: Float"
])

add_class(uml, 'ExerciseLog', [
    "+ id: Integer (PK)",
    "+ user_id: Integer (FK)",
    "+ exercise_id: Integer (FK)",
    "+ duration_minutes: Float",
    "+ date: DateTime"
])

add_class(uml, 'Goal', [
    "+ id: Integer (PK)",
    "+ user_id: Integer (FK)",
    "+ target_weight_kg: Float",
    "+ daily_calories_goal: Float",
    "+ protein_goal_g: Float",
    "+ carbs_goal_g: Float",
    "+ fat_goal_g: Float"
])

add_class(uml, 'WeightLog', [
    "+ id: Integer (PK)",
    "+ user_id: Integer (FK)",
    "+ weight_kg: Float",
    "+ date: DateTime"
])

# Define relationships
uml.edge('User', 'FoodLog', label='1..*')
uml.edge('User', 'ExerciseLog', label='1..*')
uml.edge('User', 'Goal', label='1..1')
uml.edge('User', 'WeightLog', label='1..*')
uml.edge('Food', 'FoodLog', label='1..*')
uml.edge('Exercise', 'ExerciseLog', label='1..*')

# Render and output UML Diagram
uml_path = "/mnt/data/myfitnesspal_uml.png"
uml.render(uml_path, format='png', cleanup=True)
print("UML diagram generated at:", uml_path)
