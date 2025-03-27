import 'package:count_frontend/models/scanned_food.dart';
import 'package:count_frontend/models/search_result.dart';

class SearchDto {
  static SearchResult fromJson(Map<String, dynamic> json) {
    return SearchResult(
      description: json['description'],
      calories: json['calories'],
      proteinG: json['protein_g'],
      carbsG: json['carbs_g'],
      fatG: json['fat_g'],
    );
  }

  static ScannedFood toScannedFood(SearchResult search) {
    print('asdkasldkjalkdjasd');
    return ScannedFood(
      className: search.description,
      confidence: 1,
      servingSize: 1,
      description: search.description,
      calories: search.calories,
      proteinG: search.proteinG,
      carbsG: search.carbsG,
      fatG: search.fatG,
    );
  }
}
