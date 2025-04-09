import 'package:count_frontend/dto/creation_dto.dart';
import 'package:count_frontend/dto/food_log_dto.dart';
import 'package:count_frontend/dto/search_dto.dart';
import 'package:count_frontend/dto/user_dto.dart';
import 'package:count_frontend/models/scanned_food.dart';
import 'package:count_frontend/models/search_result.dart';
import 'package:count_frontend/utility/utils.dart';
import 'package:dio/dio.dart';
import 'package:count_frontend/models/user.dart';
import 'package:count_frontend/utility/config.dart';
import 'dart:io';

class BackendApi {
  static String get url => AppConfig.url;
  static final Dio dio = Dio();

  static Future<User?> getUser(int userId) async {
    Response userRes = await dio.get('$url/user/?user_id=$userId');
    if (userRes.statusCode == HttpStatus.notFound) {
      return null;
    } else if (userRes.statusCode == HttpStatus.ok) {
      return UserDto.fromJson(userRes.data);
    }
    throw Exception(
      'Error getting user data with status: ${userRes.statusCode}',
    );
  }

  static Future<User> newUser({
    required String userName,
    required double weight,
    required double height,
    required DateTime dob,
    required String gender,
    required String activityLevel,
    double? heightGoal,
    double? weightGoal,
    double? caloryGoal,
  }) async {
    // Convert DOB to ISO8601 string
    String dobString = dob.toIso8601String();

    // Prepare the data for the request
    Map<String, dynamic> userData = {
      'user_name': userName,
      'dob': dobString, // Ensure the date is in ISO8601 format
      'gender': gender,
      'height': height,
      'weight': weight,
      'height_goal': heightGoal ?? null,
      'weight_goal': weightGoal ?? null,
      'calory_goal': caloryGoal ?? null,
    };

    // Make the POST request to the backend API to create the new user
    try {
      Response userRes = await dio.post(
        '$url/user/',
        data: userData, // Send data as JSON in the body
      );

      if (userRes.statusCode == HttpStatus.ok) {
        return UserDto.fromJson(userRes.data);
      } else {
        throw Exception(
          'Error creating new user data with status: ${userRes.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error creating user: $e');
    }
  }

  // static Future<User> newUser(String userName) async {
  //   Response userRes =
  //       await dio.post('$url/user/', queryParameters: {'user_name': userName});
  //   if (userRes.statusCode == HttpStatus.ok) {
  //     return UserDto.fromJson(userRes.data);
  //   }
  //   throw Exception(
  //     'Error creating new user data with status: ${userRes.statusCode}',
  //   );
  // }

  static Future<bool> deleteLog(int logId) async {
    Response deleteRes =
        await dio.delete('$url/log/food/', queryParameters: {'log_id': logId});
    if (deleteRes.statusCode == HttpStatus.ok) {
      return deleteRes.data['rows'] == 1;
    } else {
      return false;
    }
  }

  static Future<User> newLog(
    int userId, {
    required String name,
    required String mealTypeString,
    required DateTime date,
    required List<ScannedFood> foods,
  }) async {
    Map<String, dynamic> newLogJson = FoodLogCreationDto.toJson(
        name: name, mealTypeString: mealTypeString, date: date, foods: foods);
    Response userRes = await dio.post('$url/log/food/',
        queryParameters: {'user_id': userId}, data: newLogJson);
    if (userRes.statusCode == HttpStatus.ok) {
      return UserDto.fromJson(userRes.data);
    }
    throw Exception(
      'Error adding log data with status: ${userRes.statusCode}',
    );
  }

  static Future<List<ScannedFood>?> scanImage(File imageFile) async {
    try {
      FormData data = FormData.fromMap({
        'file': await MultipartFile.fromFile(imageFile.path,
            filename: imageFile.path.split('/').last)
      });

      Response imageRes = await dio.post('$url/log/scan/', data: data);
      if (imageRes.statusCode == HttpStatus.notFound) {
        return [];
      } else if (imageRes.statusCode == HttpStatus.ok) {
        List<Map<String, dynamic>> scannedFoods =
            castListDynamicToListMap(imageRes.data['foods']);

        return List.generate(scannedFoods.length,
            (index) => ScannedFoodDto.fromJson(scannedFoods[index]));
      } else {
        throw Exception(
            'Error scanning the image with status: ${imageRes.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<SearchResult>> search(String query) async {
    try {
      Response searchRes =
          await dio.get('$url/search/food/', queryParameters: {'query': query});

      if (searchRes.statusCode == HttpStatus.ok) {
        List<Map<String, dynamic>> searchResults =
            castListDynamicToListMap(searchRes.data['results']);

        return List.generate(searchResults.length,
            (index) => SearchDto.fromJson(searchResults[index]));
      } else {
        throw Exception(
            'Error scanning the image with status: ${searchRes.statusCode}');
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
