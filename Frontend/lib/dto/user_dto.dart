import 'package:count_frontend/dto/food_log_dto.dart';
import 'package:count_frontend/models/user.dart';
import 'package:count_frontend/utility/utils.dart';

class UserDto {
  static User fromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>> logs =
        castListDynamicToListMap(json['food_logs']);
    int userId = json['user_id'];

    return User(
      id: userId,
      username: json['user_name'],
      foodLogs: List.generate(
        logs.length,
        (index) => FoodLogDto.fromJson(logs[index], userId: userId),
      ),
    );
  }
}
