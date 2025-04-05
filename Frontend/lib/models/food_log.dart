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
    // print(calories);
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

  static double getTotalCalories(List<FoodLog> foodLogs) {
  double totalCalories = 0;
  for (var log in foodLogs) {
    totalCalories += log.totalCalories; 
  }
  return totalCalories;
}
  static double getTotalProtein(List<FoodLog> foodLogs) {
  double totalProtein = 0;
  for (var log in foodLogs) {
    totalProtein += log.totalProtein; 
  }
  return totalProtein;
}
  static double getTotalFat(List<FoodLog> foodLogs) {
  double totalFat = 0;
  for (var log in foodLogs) {
    totalFat += log.totalFat; 
  }
  return totalFat;
}
  static double getTotalCarb(List<FoodLog> foodLogs) {
  double totalCarb = 0;
  for (var log in foodLogs) {
    totalCarb += log.totalCarbs; 
  }
  return totalCarb;
}

}
