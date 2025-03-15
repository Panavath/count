class Goal {
  final int id;
  final int userId;
  final double? targetWeightKg;
  final double? dailyCaloriesGoal;
  final double? proteinGoalG;
  final double? carbsGoalG;
  final double? fatGoalG;

  Goal({
    required this.id,
    required this.userId,
    this.targetWeightKg,
    this.dailyCaloriesGoal,
    this.proteinGoalG,
    this.carbsGoalG,
    this.fatGoalG,
  });
}