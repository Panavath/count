import 'package:count_frontend/enums/meal_types.dart';
import 'package:count_frontend/models/food.dart';
import 'package:count_frontend/models/food_log.dart';
import 'package:count_frontend/models/scanned_food.dart';
import 'package:count_frontend/utility/utils.dart';

class FoodLogDto {
  static FoodLog fromJson(Map<String, dynamic> json, {required int userId}) {
    List<Map<String, dynamic>> foods = castListDynamicToListMap(json['foods']);

    return FoodLog(
      foodLogId: json['food_log_id'],
      name: json['name'],
      mealType: MealType.fromString(json['meal_type']),
      date: DateTime.parse(json['date']),
      foods: List.generate(
        foods.length,
        (index) => FoodDto.fromJson(foods[index]),
      ),
    );
  }

  static Map<String, dynamic> toJson(FoodLog log) {
    return {
      'food_log_id': log.foodLogId,
      'name': log.name,
      'meal_type': log.mealType.value,
      'date': log.date.toIso8601String(),
      'foods': List.generate(
        log.foods.length,
        (index) => FoodDto.toJson(log.foods[index]),
      )
    };
  }
}

class FoodDto {
  static Food fromJson(Map<String, dynamic> json) {
    return Food(
      foodId: json['food_id'],
      name: json['name'],
      calories: json['calories'],
      proteinG: json['protein_g'],
      carbsG: json['carbs_g'],
      fatG: json['fat_g'],
      servingSize: json['serving_size'],
    );
  }

  static Map<String, dynamic> toJson(Food food) {
    return {
      'food_id': food.foodId,
      'name': food.name,
      'serving_size': food.servingSize,
      'calories': food.calories,
      'protein_g': food.proteinG,
      'carbs_g': food.carbsG,
      'fat_g': food.fatG,
    };
  }
}

class FoodLogCreationDto {
  static Map<String, dynamic> toJson({
    required String name,
    required String mealTypeString,
    required DateTime date,
    required List<ScannedFood> foods,
  }) {
    return {
      'name': name,
      'meal_type': mealTypeString,
      'date': date.toIso8601String(),
      'foods': List.generate(
        foods.length,
        (index) => FoodCreationDto.toJson(foods[index]),
      ),
    };
  }
}

class FoodCreationDto {
  static Map<String, dynamic> toJson(ScannedFood food) {
    return {
      'name': food.className,
      'serving_size': food.servingSize,
      'unit': 'g', // TODO
      'calories': food.calories,
      'protein_g': food.proteinG,
      'carbs_g': food.carbsG,
      'fat_g': food.fatG,
    };
  }
}

class ScannedFoodDto {
  static ScannedFood fromJson(Map<String, dynamic> json) {
    return ScannedFood(
      className: json['class_name'],
      confidence: json['confidence'],
      servingSize: json['serving_size'] ?? 1,
      description: json['nutrition_info']['description'],
      calories: json['nutrition_info']['calories'],
      proteinG: json['nutrition_info']['protein_g'],
      carbsG: json['nutrition_info']['carbs_g'],
      fatG: json['nutrition_info']['fat_g'],
    );
  }

  static Map<String, dynamic> toJson(ScannedFood food) {
    return {
      'class_name': food.className,
      'confidence': food.confidence,
      'description': food.description,
      'serving_size': food.servingSize,
      'calories': food.calories,
      'protein_g': food.proteinG,
      'carbs_g': food.carbsG,
      'fat_g': food.fatG,
    };
  }
}
