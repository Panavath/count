import 'package:count_frontend/models/food_log.dart';

class User {
  final int id;
  final String username;
  final List<FoodLog> foodLogs;

  User({required this.id, required this.username, required this.foodLogs});
}
// class User {
//   final int id;
//   final String username;
//   final String email;
//   final int? age;
//   final String? gender;
//   final double? heightCm;
//   final double? weightKg;
//   final double? dailyCaloriesGoal;
//   final double? proteinGoalG;
//   final double? carbsGoalG;
//   final double? fatGoalG;
//   final DateTime createdAt;

//   User({
//     required this.id,
//     required this.username,
//     required this.email,
//     this.age,
//     this.gender,
//     this.heightCm,
//     this.weightKg,
//     this.dailyCaloriesGoal,
//     this.proteinGoalG,
//     this.carbsGoalG,
//     this.fatGoalG,
//     required this.createdAt,
//   });
// }
