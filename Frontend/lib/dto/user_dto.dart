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
      weightGoal: json['weight_goal'],
      weightKg: json['weight'],
      heightCm: json['height'],
      caloriesGoal: json['calory_goal'],
      dob: DateTime.parse(json['dob']),
      foodLogs: List.generate(
        logs.length,
        (index) => FoodLogDto.fromJson(logs[index], userId: userId),
      ),
    );
  }
}
