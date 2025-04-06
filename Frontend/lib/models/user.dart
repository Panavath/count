import 'package:count_frontend/enums/activity.dart';
import 'package:count_frontend/models/food_log.dart';

class User {
  final int id;
  final String username;
  final String? gender;

  final DateTime? dob;
  final List<FoodLog> foodLogs;
  final double? heightCm;
  final double? weightKg;
  final double? weightGoal;
  final double? caloriesGoal;
  final double? proteinGoal;
  final double? carbsGoal;
  final double? fatGoal;
  final String? activityLevel;
  final DateTime? createdAt;

  User(
      {required this.id,
      required this.username,
      required this.foodLogs,
      this.caloriesGoal,
      this.gender,
      this.dob,
      this.weightGoal,
      this.heightCm,
      this.proteinGoal,
      this.carbsGoal,
      this.createdAt,
      this.fatGoal,
      this.activityLevel,
      this.weightKg});

    int get age {
    if (dob == null) {
      return 0;
    }
    DateTime today = DateTime.now();
    int yearsDifference = today.year - dob!.year;
    if (today.month < dob!.month || (today.month == dob!.month && today.day < dob!.day)) {
      yearsDifference--;
    }
    return yearsDifference;
  }

  // Calculate BMR
  double calculateBMR() {
    if (gender == 'male') {
      // Mifflin-St Jeor equation for male
      return 10 * (weightKg ?? 0) + 6.25 * (heightCm ?? 0) - 5 * (age ?? 0) + 5;
    } else {
      // Mifflin-St Jeor equation for female
      return 10 * (weightKg ?? 0) +
          6.25 * (heightCm ?? 0) -
          5 * (age ?? 0) -
          161;
    }
  }

  double calculateTDEE(ActivityLevel activityLevel) {
    double bmr = calculateBMR();
    return bmr * activityLevel.activityFactor;
  }

  Map<String, double> calculateGoals(ActivityLevel activityLevel) {
    double tdee = calculateTDEE(activityLevel);
    double proteinGoal = (tdee * 0.30) / 4; // 30% of TDEE as protein
    double carbGoal = (tdee * 0.40) / 4; // 40% of TDEE as carbs
    double fatGoal = (tdee * 0.30) / 9; // 30% of TDEE as fat
    return {
      'calories': tdee,
      'protein': proteinGoal,
      'carbs': carbGoal,
      'fat': fatGoal,
    };
  }

  
}
