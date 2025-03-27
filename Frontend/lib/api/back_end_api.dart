import 'package:count_frontend/dto/food_log_dto.dart';
import 'package:count_frontend/dto/user_dto.dart';
import 'package:count_frontend/models/scanned_food.dart';
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

  static Future<User> newUser(String userName) async {
    Response userRes = await dio.post('$url/user/?user_name=$userName');
    if (userRes.statusCode == HttpStatus.ok) {
      return UserDto.fromJson(userRes.data);
    }
    throw Exception(
      'Error creating new user data with status: ${userRes.statusCode}',
    );
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
    Response userRes =
        await dio.post('$url/log/food/?user_id=$userId', data: newLogJson);
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
        return null;
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
}
