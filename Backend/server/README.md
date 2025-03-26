## Endpoints

### User

1. **GET** `/user/?user_id={int}`:

    Args:

    - `user_id` (Query, int)

    Returns:

    - `UserSchema`: the user data alongside their entire log history.

2. **POST** `/user/?user_name={str}`:

    Args:

    - `user_name` (Query, str): Not final

    Returns:

    - `UserSchema`: A fresh user data with the logs as an empty list

3. **GET** `/user/all/`:
   For debugging only.

    Returns:

    - `{"users": list[UserSchema]}`

### Log

1. **POST** `/log/scan/`:

    Args:

    - `file` (File)

    Returns:

    - `{"foods": list[FoodSchema]}`: list of every detected foods.

2. **POST** `/log/food/?user_id={int}`:

    Args:

    - `user_id` (Query, int): The id of the user to add the log to

    Body:

    - `FoodLogCreationSchema`: The food log with the foods selected.

    Returns:

    - `UserSchema`: The updated user data.

### Search

1. **GET** `/search/food?query={str}`:

    Args:

    - `query` (Query, str): The search query.

    Returns:

    - `{"results": list[EdamamNutritionInfoSchema]}`: list of matching food names and their nutrition data

## Schemas

### UserSchema

```json
{
  "user_id": int,
  "user_name": str,
  "food_logs": [FoodLogSchema]
}
```

### FoodLogSchema

```json
{
  "food_log_id": int,
  "name": str,
  "meal_type": str, // Enum
  "date": str, // DateTime in string format
  "foods": [FoodSchema]
}
```

### FoodLogCreationSchema

```json
{
  "name": str,
  "meal_type": str, // Enum
  "date": str, // DateTime in string format
  "foods": [FoodCreationSchema]
}
```

### FoodSchema

```json
{
  "food_id": int,
  "name": str,
  "serving_size": float,
  "unit": str, // Not used for now
  "calories": float,
  "protein_g": float,
  "carbs_g": float,
  "fat_g": float
}
```

### FoodCreationSchema

```json
{
  "name": str,
  "serving_size": float,
  "unit": str, // Not used for now
  "calories": float,
  "protein_g": float,
  "carbs_g": float,
  "fat_g": float
}
```

### ScannedFoodWithInfoSchema

```json
{
  "class_name": str, // Aka. food name
  "confidence": float, // A value from 0.0 to 1.0, higher means more confidence
  "bbox": [int], // Should be ignored
  "nutrition_info": EdamamNutritionInfoSchema
}
```

### EdamamNutritionInfoSchema

```json
{
  "description": str, // aka. food name or class name
  "calories": float,
  "protein_g": float,
  "carbs_g": float,
  "fat_g": float
}
```
