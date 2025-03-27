import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserDataProvider with ChangeNotifier {
  int userId = 4;

  List<Map<String, dynamic>> _foodHistory = [];

  List<Map<String, dynamic>> get foodHistory => _foodHistory;

  String? _imagePath;

  String? get imagePath => _imagePath;

  // Method to update image path
  void setImagePath(String path) {
    _imagePath = path;
    notifyListeners();  // Notify listeners to update the UI
  }

   Future<void> addFoodHistory(List<dynamic> food, String foodName, String mealType) async {
    try {
      final url = Uri.parse('http://10.0.2.2:727/log/food/?user_id=${userId}'); // Correct URL

      // Prepare the payload to send to the backend
      final payload = json.encode({
        'name': foodName,  // Dynamic food name
        'meal_type': mealType,  // Dynamic meal type
        'date': DateTime.now().toIso8601String(),  // Current date and time
        'foods': food.map((f) {
          return {
            'name': f['class_name'] ?? 'Unknown',  // Default to 'Unknown' if null
            'serving_size': f['nutrition_info']['serving_size'] ?? 1.0,  // Default to 1.0 if null
            'unit': f['nutrition_info']['unit'] ?? 'g',  // Default to 'g' if null
            'calories': f['nutrition_info']['calories'] ?? 0.0,
            'protein_g': f['nutrition_info']['protein_g'] ?? 0.0,
            'carbs_g': f['nutrition_info']['carb_g'] ?? 0.0,  // Correct typo if needed
            'fat_g': f['nutrition_info']['fat_g'] ?? 0.0,
          };
        }).toList(),
      });

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: payload,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        print('Response data: $data');

        // Ensure 'food_logs' exists and is not empty
        if (data['food_logs'] != null && data['food_logs'].isNotEmpty) {
          // Create a List to hold the formatted food logs
          List<Map<String, dynamic>> foodLogs = [];

          // Loop through food_logs in the backend response
          for (var foodLog in data['food_logs']) {
            List<Map<String, dynamic>> foods = [];
            
            // Process the 'foods' in each food log
            for (var food in foodLog['foods']) {
              foods.add({
                'food_id': food['food_id'] ?? 0, // Ensure a valid food_id
                'name': food['name'] ?? 'Unknown', // Ensure a valid name
                'serving_size': food['serving_size'] ?? 1.0,
                'unit': food['unit'] ?? 'g',
                'calories': food['calories'] ?? 0.0,
                'protein_g': food['protein_g'] ?? 0.0,
                'carbs_g': food['carbs_g'] ?? 0.0,
                'fat_g': food['fat_g'] ?? 0.0,
              });
            }

            foodLogs.add({
              'food_log_id': foodLog['food_log_id'] ?? 0,
              'name': foodLog['name'] ?? 'Unknown',
              'meal_type': foodLog['meal_type'] ?? 'Unknown',
              'date': foodLog['date'] ?? DateTime.now().toIso8601String(),
              'foods': foods,
            });
          }

          // Update the _foodHistory list with the formatted food logs
          _foodHistory.addAll(foodLogs);

          // Notify listeners to update the UI
          notifyListeners();
          
          print("Food history after adding data: $_foodHistory");
        } else {
          print('No food logs found in response.');
        }
      } else {
        print('Failed to add food history. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to add food history');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to add food history');
    }
  }

}


//     'http://10.0.2.2:727/log/food/?user_id=${userId}'