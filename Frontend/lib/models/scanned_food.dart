class ScannedFood {
  final String className;
  final double confidence;
  final String description;
  final double calories;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final double servingSize;

  ScannedFood({
    required this.className,
    required this.confidence,
    required this.description,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.servingSize,
  });

  @override
  String toString() {
    return 'ScannedFood(cls=$className, des=$description, cal=$calories)';
  }

  @override
  bool operator ==(Object other) {
    return other is ScannedFood &&
        other.className == className &&
        other.description == description;
  }

  @override
  int get hashCode => className.hashCode ^ description.hashCode;
}
