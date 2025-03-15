class FoodLog {
  final int id;
  final int userId;
  final int foodId;
  final double quantity;
  final String mealType;
  final DateTime date;

  FoodLog({
    required this.id,
    required this.userId,
    required this.foodId,
    required this.quantity,
    required this.mealType,
    required this.date,
  });
}