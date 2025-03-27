import 'package:count_frontend/models/scanned_food.dart';

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
