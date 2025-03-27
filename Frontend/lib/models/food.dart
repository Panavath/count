class Food {
  final int? foodId;
  final String name;
  final double calories;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final double servingSize;

  Food({
    this.foodId,
    required this.name,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.servingSize,
  });
}
