enum MealType {
  breakfast('Breakfast'),
  lunch('Lunch'),
  dinner('Dinner'),
  snack('Snack');

  const MealType(this.value);

  final String value;

  static MealType fromString(String value) {
    for (MealType type in MealType.values) {
      if (type.value == value) return type;
    }
    throw Exception('Unknown food log type enum.');
  }
}
