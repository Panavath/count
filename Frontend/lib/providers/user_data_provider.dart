import 'package:count_frontend/dto/user_dto.dart';
import 'package:count_frontend/models/goal.dart';
import 'package:count_frontend/models/scanned_food.dart';
import 'package:count_frontend/models/user.dart';
import 'package:count_frontend/providers/async_value.dart';
import 'package:count_frontend/api/back_end_api.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class UserDataProvider with ChangeNotifier {
  static const userIdKey = 'user_id';
  static const userNameKey = 'user_name';  
  static const weightKey = 'weight';  
  static const heightKey = 'height';  
  static const weightGoalKey = 'weight_goal';  
  static const caloriesGoalKey = 'calory_goal';  
  static const proteinGoalKey = 'protein_goal';
  static const fatGoalKey = 'fat_goal';    
  static const carbGoalKey = 'carb_goal';  
  static const genderKey = 'gender';  
  static const activityLevelKey = "";
  static const dobKey = 'dob';  

  bool isLoggedIn = false;
  bool loadingLogs = false;
  AsyncValue<User> currentUser = AsyncValue.none();

  String? _imagePath;
  String? get imagePath => _imagePath;

  Goal? userGoal;

  UserDataProvider() {
    logIn();  // Attempt to load user data on initialization
  }

  void setImagePath(String path) {
    _imagePath = path;
    notifyListeners();
  }

  // Save the user goal and other data
Future<void> setUserGoal({
  required double weight,
  required double weightGoal,
  required double height,
  required DateTime dob,
  required String gender,
  required String activityLevel,
  required int currentUserId,
  required String username, // Add username parameter
  required double proteinGoal, // Add macros
  required double carbGoal,
  required double fatGoal,
}) async {
  int age = User(dob: dob, id: -1, username: '', foodLogs: []).age;
  double bmr = calculateBMR(weight, height, age, gender);
  double tdee = calculateTDEE(bmr, activityLevel);
  double caloriesGoal = tdee;

  SharedPreferences prefs = await SharedPreferences.getInstance();
  
  // Save ALL user data
  prefs.setInt(userIdKey, currentUserId);
  prefs.setString(userNameKey, username);
  prefs.setDouble(weightKey, weight);
  prefs.setDouble(heightKey, height);
  prefs.setDouble(weightGoalKey, weightGoal);
  prefs.setDouble(caloriesGoalKey, caloriesGoal);
  prefs.setString(genderKey, gender);
  prefs.setString(activityLevelKey, activityLevel);
  prefs.setString(dobKey, dob.toIso8601String());
  prefs.setDouble(proteinGoalKey, proteinGoal);
  prefs.setDouble(carbGoalKey, carbGoal);
  prefs.setDouble(fatGoalKey, fatGoal);

  currentUser.data = User(
    id: currentUserId,
    username: username,
    foodLogs: currentUser.data!.foodLogs,
    heightCm: height,
    weightKg: weight,
    dob: dob,
    gender: gender,
    caloriesGoal: caloriesGoal,
    proteinGoal: proteinGoal,
    carbsGoal: carbGoal,
    fatGoal: fatGoal,
    activityLevel: activityLevel,
    weightGoal: weightGoal,
  );

  notifyListeners();
}

  double calculateBMR(double weight, double height, int age, String gender) {
    if (gender == 'male') {
      return 10 * weight + 6.25 * height - 5 * age + 5;
    } else {
      return 10 * weight + 6.25 * height - 5 * age - 161;
    }
  }

  double calculateTDEE(double bmr, String activityLevel) {
    double activityFactor = 1.55;  // Default for "moderately_active"
    if (activityLevel == 'sedentary') {
      activityFactor = 1.2;
    } else if (activityLevel == 'lightly_active') {
      activityFactor = 1.375;
    } else if (activityLevel == 'very_active') {
      activityFactor = 1.725;
    }

    return bmr * activityFactor;  // Total Daily Energy Expenditure (TDEE)
  }

 Future<void> logIn() async {
  currentUser = AsyncValue.loading();
  notifyListeners();

  try {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int? pastUserId = pref.getInt(userIdKey);

    if (pastUserId == null) {
      currentUser = AsyncValue.empty();
      notifyListeners();
      return;
    }

    // Retrieve ALL saved data
    String? username = pref.getString(userNameKey);
    double weightKg = pref.getDouble(weightKey) ?? 0.0;
    double heightCm = pref.getDouble(heightKey) ?? 0.0;
    double weightGoal = pref.getDouble(weightGoalKey) ?? 0.0;
    double caloriesGoal = pref.getDouble(caloriesGoalKey) ?? 0.0;
    String gender = pref.getString(genderKey) ?? 'male';
    String activityLevel = pref.getString(activityLevelKey) ?? 'moderately_active';
    String dobString = pref.getString(dobKey) ?? '';
    DateTime dob = DateTime.tryParse(dobString) ?? DateTime.now();
    double proteinGoal = pref.getDouble(proteinGoalKey) ?? 0.0;
    double carbsGoal = pref.getDouble(carbGoalKey) ?? 0.0;
    double fatGoal = pref.getDouble(fatGoalKey) ?? 0.0;

    User user = User(
      id: pastUserId,
      username: username ?? '',
      foodLogs: [], // Food logs should be fetched separately
      heightCm: heightCm,
      weightKg: weightKg,
      weightGoal: weightGoal,
      caloriesGoal: caloriesGoal,
      gender: gender,
      activityLevel: activityLevel,
      dob: dob,
      proteinGoal: proteinGoal,
      carbsGoal: carbsGoal,
      fatGoal: fatGoal,
    );

    currentUser = AsyncValue.success(user);
    isLoggedIn = true;
  } catch (e) {
    currentUser = AsyncValue.error(e);
  }

  notifyListeners();
}

  Future<void> newLog({
  required String name,
  required String mealTypeString,
  required DateTime date,
  required List<ScannedFood> foods,
}) async {
  loadingLogs = true;
  notifyListeners();

  try {
    User newUser = await BackendApi.newLog(
      currentUser.data!.id,
      name: name,
      mealTypeString: mealTypeString,
      date: date,
      foods: foods,
    );
    
    // Preserve all existing user data
    currentUser = AsyncValue.success(User(
      id: newUser.id,
      username: currentUser.data!.username,
      foodLogs: newUser.foodLogs,
      heightCm: currentUser.data!.heightCm,
      weightKg: currentUser.data!.weightKg,
      weightGoal: currentUser.data!.weightGoal,
      caloriesGoal: currentUser.data!.caloriesGoal,
      gender: currentUser.data!.gender,
      activityLevel: currentUser.data!.activityLevel,
      dob: currentUser.data!.dob,
      proteinGoal: currentUser.data!.proteinGoal,
      carbsGoal: currentUser.data!.carbsGoal,
      fatGoal: currentUser.data!.fatGoal,
    ));
  } catch (e) {
    // Handle error
  } finally {
    loadingLogs = false;
    notifyListeners();
  }
}
Future<void> signUp({
  required String userName,
  required double weight,
  required double height,
  required DateTime dob,
  required String gender,
  required String activityLevel,
  double? heightGoal, // Optional goal parameters
  double? weightGoal,
  double? caloryGoal,
}) async {
  currentUser = AsyncValue.loading();
  notifyListeners();

  try {
    // Calculate goals
    double caloriesGoal = calculateTDEE(weight, activityLevel); // Calculate TDEE
    double proteinGoal = (caloriesGoal * 0.30) / 4;
    double carbGoal = (caloriesGoal * 0.40) / 4;
    double fatGoal = (caloriesGoal * 0.30) / 9;

    User user = await BackendApi.newUser(userName: userName, 
    weight: weight, 
    height: height, 
    dob: dob, gender: gender, activityLevel: activityLevel);

 
    User newUser = User(
      id: user.id, // Unique ID (for simplicity)
      username: userName,
      weightKg: weight,
      heightCm: height,
      dob: dob,
      gender: gender,
      activityLevel: activityLevel,
      caloriesGoal: caloriesGoal,
      proteinGoal: proteinGoal,
      carbsGoal: carbGoal,
      fatGoal: fatGoal,
      foodLogs: [],
    );

    // Save user data to SharedPreferences
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt(userIdKey, newUser.id);
    pref.setString(userNameKey, newUser.username);
    pref.setDouble(weightKey, newUser.weightKg!);
    pref.setDouble(heightKey, newUser.heightCm!);
    pref.setDouble(weightGoalKey, weightGoal ?? newUser.weightKg!); // Save weightGoal
    pref.setDouble(caloriesGoalKey, newUser.caloriesGoal!);
    pref.setString(genderKey, newUser.gender!);
    pref.setString(activityLevelKey, newUser.activityLevel!);
    pref.setString(dobKey, newUser.dob!.toIso8601String());
    
    // Save macro goals
    pref.setDouble(proteinGoal.toString(), newUser.proteinGoal!);
    pref.setDouble(carbGoal.toString(), newUser.carbsGoal!);
    pref.setDouble(fatGoal.toString(), newUser.fatGoal!);

    // Set the current user to the newly created user
    currentUser = AsyncValue.success(user);
    isLoggedIn = true;

    // Recalculate goals
    setUserGoal(
      weight: newUser.weightKg!,
      weightGoal: weightGoal ?? newUser.weightKg!,
      height: newUser.heightCm!,
      gender: newUser.gender!,
      activityLevel: newUser.activityLevel!,
      currentUserId: newUser.id,
      dob: newUser.dob!, username: newUser.username, proteinGoal: newUser.proteinGoal!, carbGoal: newUser.carbsGoal!, fatGoal: newUser.fatGoal!,
    );

    notifyListeners();
  } catch (e) {
    currentUser = AsyncValue.error(e);
    notifyListeners();
  }
}

}
