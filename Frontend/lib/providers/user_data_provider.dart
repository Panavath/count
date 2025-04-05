import 'package:count_frontend/models/scanned_food.dart';
import 'package:count_frontend/models/user.dart';
import 'package:count_frontend/providers/async_value.dart';
import 'package:count_frontend/api/back_end_api.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDataProvider with ChangeNotifier {
  static const userIdKey = 'user_id';
  bool isLoggedIn = false;
  bool loadingLogs = false;
  AsyncValue<User> currentUser = AsyncValue.none();

  String? _imagePath;
  String? get imagePath => _imagePath;

  UserDataProvider() {
    logIn();
  }

  void setImagePath(String path) {
    _imagePath = path;
    notifyListeners();
  }

  Future<void> logIn() async {
    currentUser = AsyncValue.loading();
    notifyListeners();
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      int? pastUserId = pref.getInt(userIdKey);
      if (pastUserId == null) {
        currentUser = AsyncValue.empty();
      } else {
        User? user = await BackendApi.getUser(pastUserId);
        if (user == null) {
          currentUser = AsyncValue.empty();
        } else {
          currentUser = AsyncValue.success(user);
          isLoggedIn = true;
        }
      }
    } catch (e) {
      currentUser = AsyncValue.error(e);
    }
    notifyListeners();
  }

  Future<void> signUp(String userName) async {
    currentUser = AsyncValue.loading();
    notifyListeners();

    User newUser = await BackendApi.newUser(userName);
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt(userIdKey, newUser.id);
    currentUser = AsyncValue.success(newUser);
    isLoggedIn = true;
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

    User newUser = await BackendApi.newLog(
      currentUser.data!.id,
      name: name,
      mealTypeString: mealTypeString,
      date: date,
      foods: foods,
    );
    currentUser = AsyncValue.success(newUser);
    loadingLogs = false;
    notifyListeners();
  }

  // Future<void> addFoodHistory(
  //     List<dynamic> food, String foodName, String mealType) async {
  //   try {
  //     final url = Uri.parse(
  //         'http://127.0.0.1:727/log/food/?user_id=${userId}'); // Correct URL

  //     // Prepare the payload to send to the backend
  //     final payload = json.encode({
  //       'name': foodName, // Dynamic food name
  //       'meal_type': mealType, // Dynamic meal type
  //       'date': DateTime.now().toIso8601String(), // Current date and time
  //       'foods': food.map((f) {
  //         return {
  //           'name':
  //               f['class_name'] ?? 'Unknown', // Default to 'Unknown' if null
  //           'serving_size': f['nutrition_info']['serving_size'] ??
  //               1.0, // Default to 1.0 if null
  //           'unit':
  //               f['nutrition_info']['unit'] ?? 'g', // Default to 'g' if null
  //           'calories': f['nutrition_info']['calories'] ?? 0.0,
  //           'protein_g': f['nutrition_info']['protein_g'] ?? 0.0,
  //           'carbs_g':
  //               f['nutrition_info']['carbs_g'] ?? 0.0, // Correct typo if needed
  //           'fat_g': f['nutrition_info']['fat_g'] ?? 0.0,
  //         };
  //       }).toList(),
  //     });

  //     final response = await http.post(
  //       url,
  //       headers: {'Content-Type': 'application/json'},
  //       body: payload,
  //     );

  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);

  //       print('Response data: $data');

  //       // Ensure 'food_logs' exists and is not empty
  //       if (data['food_logs'] != null && data['food_logs'].isNotEmpty) {
  //         // Create a List to hold the formatted food logs
  //         List<Map<String, dynamic>> foodLogs = [];

  //         // Loop through food_logs in the backend response
  //         for (var foodLog in data['food_logs']) {
  //           List<Map<String, dynamic>> foods = [];

  //           // Process the 'foods' in each food log
  //           for (var food in foodLog['foods']) {
  //             foods.add({
  //               'food_id': food['food_id'] ?? 0, // Ensure a valid food_id
  //               'name': food['name'] ?? 'Unknown', // Ensure a valid name
  //               'serving_size': food['serving_size'] ?? 1.0,
  //               'unit': food['unit'] ?? 'g',
  //               'calories': food['calories'] ?? 0.0,
  //               'protein_g': food['protein_g'] ?? 0.0,
  //               'carbs_g': food['carbs_g'] ?? 0.0,
  //               'fat_g': food['fat_g'] ?? 0.0,
  //             });
  //           }

  //           foodLogs.add({
  //             'food_log_id': foodLog['food_log_id'] ?? 0,
  //             'name': foodLog['name'] ?? 'Unknown',
  //             'meal_type': foodLog['meal_type'] ?? 'Unknown',
  //             'date': foodLog['date'] ?? DateTime.now().toIso8601String(),
  //             'foods': foods,
  //           });
  //         }

  //         // Update the _foodHistory list with the formatted food logs
  //         _foodHistory.addAll(foodLogs);

  //         // Notify listeners to update the UI
  //         notifyListeners();

  //         debugPrint("Food history after adding data: $_foodHistory");
  //       } else {
  //         debugPrint('No food logs found in response.');
  //       }
  //     } else {
  //       debugPrint(
  //           'Failed to add food history. Status code: ${response.statusCode}');
  //       debugPrint('Response body: ${response.body}');
  //       throw Exception('Failed to add food history');
  //     }
  //   } catch (e) {
  //     debugPrint('Error: $e');
  //     throw Exception('Failed to add food history');
  //   }
  // }
}
