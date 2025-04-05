## Endpoints

### User

1. **GET** `/user/?user_id={int}`:

    Args:
    - `user_id` (Query, int)

    Returns: `UserSchema`: the user data alongside their entire log history.

2. **POST** `/user/`:

    Args:
    - `user_name` (UserCreationSchema)

    Returns: `UserSchema`: A fresh user data with the logs as an empty list

3. **DELETE** `/user/?user_id={int}`:

    Args:
    - `user_id` (Query, int)

    Returns: No content

4. **GET** `/user/all/`:

   For debugging only.

    Returns: `{"users": list[UserSchema]}`

### Log

1. **POST** `/log/scan/`:

    Args:
    - `file` (File)

    Returns: `{"foods": list[ScannedFoodWithInfoSchema]}`: list of every detected foods.

2. **POST** `/log/food/?user_id={int}`:

    Args:
    - `user_id` (Query, int): The id of the user to add the log to

    Body: `FoodLogCreationSchema`: The food log with the foods selected.

    Returns: `UserSchema`: The updated user data.

3. **DELETE** `/log/food/?log_id={int}`:

    Args:
    - `log_id` (Query, int): The id of log ot delete

    Returns: `{'status': int, 'rows': int}`: the status and rows that were deleted (0 or 1),

### Search

1. **GET** `/search/food?query={str}`:

    Args:
    - `query` (Query, str): The search query.

    Returns: `{"results": list[EdamamNutritionInfoSchema]}`: list of matching food names and their nutrition data

## Schemas

### UserSchema

```json
{
  "user_id": "int",
  "user_name": "str",
  "dob": "str", // DateTime in string format
  "gender": "str", // 'male' or 'female'
  "height": "float", // PositiveFloat
  "weight": "float", // PositiveFloat
  "register_date": "str", // DateTime in string format
  "height_goal": "float or null",
  "weight_goal": "float or null",
  "calory_goal": "float or null",
  "height_logs": ["HeightLogSchema"],
  "weight_logs": ["WeightLogSchema"],
  "food_logs": ["FoodLogSchema"],
}
```

### UserCreationSchema

```json
{
  "user_name": "str",
  "dob": "str", // DateTime in string format
  "gender": "str", // 'male' or 'female'
  "height": "float", // PositiveFloat
  "weight": "float", // PositiveFloat
  "height_goal": "float or null",
  "weight_goal": "float or null",
  "calory_goal": "float or null",
}
```

### FoodLogSchema

```json
{
  "food_log_id": "int",
  "name": "str",
  "meal_type": "str", // Enum
  "date": "str", // DateTime in string format
  "foods": ["FoodSchema"]
}
```

### WeightLogSchema

```json
{
  "weight_log_id": "int",
  "weight": "float",
  "date": "str", // DateTime in string format
}
```

### HeightLogSchema

```json
{
  "height_log_id": "int",
  "height": "float",
  "date": "str", // DateTime in string format
}
```

### FoodLogCreationSchema

```json
{
  "name": "str",
  "meal_type": "str", // Enum
  "date": "str", // DateTime in string format
  "foods": ["FoodCreationSchema"]
}
```

### FoodCreationSchema

```json
{
  "name": "str",
  "serving_size": "float",
  "unit": "str", // Not used for now
  "calories": "float",
  "protein_g": "float",
  "carbs_g": "float",
  "fat_g": "float"
}
```

### FoodSchema

```json
{
  "food_id": "int",
  "name": "str",
  "serving_size": "float",
  "unit": "str", // Not used for now
  "calories": "float",
  "protein_g": "float",
  "carbs_g": "float",
  "fat_g": "float"
}
```

### ScannedFoodWithInfoSchema

```json
{
  "class_name": "str", // Aka. food name
  "confidence": "float", // A value from 0.0 to 1.0, higher means more confidence
  "bbox": ["int"], // Should be ignored
  "nutrition_info": "EdamamNutritionInfoSchema"
}
```

### EdamamNutritionInfoSchema

```json
{
  "description": "str", // aka. food name or class name
  "calories": "float",
  "protein_g": "float",
  "carbs_g": "float",
  "fat_g": "float"
}
```
