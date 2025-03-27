import 'package:count_frontend/models/food.dart';

class FoodLog {
  final int id;
  final int userId;
  final int foodId;
  final double quantity;
  final String mealType;
  final DateTime date;
  final Food food;

  FoodLog({
    required this.id,
    required this.userId,
    required this.foodId,
    required this.quantity,
    required this.mealType,
    required this.date,
    required this.food
  });
}
