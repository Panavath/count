import 'package:count_frontend/enums/meal_types.dart';
import 'package:count_frontend/models/food.dart';

class FoodLog {
  final int? foodLogId;
  final String name;
  final MealType mealType;
  final DateTime date;
  final List<Food> foods;

  FoodLog({
    this.foodLogId,
    required this.name,
    required this.mealType,
    required this.date,
    required this.foods,
  });

  double get totalCalories {
    double calories = 0;
    for (Food food in foods) {
      calories += food.calories;
    }
    return calories;
  }

  double get totalProtein {
    double protein = 0;
    for (Food food in foods) {
      protein += food.proteinG;
    }
    return protein;
  }

  double get totalCarbs {
    double carbs = 0;
    for (Food food in foods) {
      carbs += food.carbsG;
    }
    return carbs;
  }

  double get totalFat {
    double fat = 0;
    for (Food food in foods) {
      fat += food.fatG;
    }
    return fat;
  }
}
