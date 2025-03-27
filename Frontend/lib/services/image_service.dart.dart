import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';

final dio = Dio();

class ImageService {
  static final String baseUrl = "http://10.0.2.2:727";


  /// Uploads an image and returns structured food choices
  static Future<List<Map<String,dynamic>>?> uploadImage(File imageFile) async {
    try {

      FormData data = FormData.fromMap({
        'file': await MultipartFile.fromFile(imageFile.path,filename: imageFile.path.split('/').last)
      });
      var response = await dio.post(baseUrl+'/log/scan/', data: data);

      var responseData = response.data;

      print("Response Body: $responseData");


      if (response.statusCode == 200) {
        print("Image successfully uploaded");
        List<Map<String, dynamic>> foundFoods = [];
        for (dynamic entry in responseData['foods']) {
          foundFoods.add({
            'class_name': entry['class_name'],
            'confidence': entry['confidence'],
            'nutrition_info': {
              'description': entry['nutrition_info']['description'],
              'calories': entry['nutrition_info']['calories'],
              'protein_g': entry['nutrition_info']['protein_g'],
              'fat_g': entry['nutrition_info']['fat_g'],
              'carb_g':entry['nutrition_info']['carbs_g']
            }
          });
        }
        return foundFoods;
      } else {
        print("Upload failed: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Failed to upload image: $e");
      rethrow;
    }
  }
}
