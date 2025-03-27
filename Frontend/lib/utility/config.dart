import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static late String environment;
  static late String url;

  static void initialize() {
    try {
      String devEnv = dotenv.get('ENVIRONMENT');

      switch (devEnv) {
        case 'WINDOWS':
          url = dotenv.get('DEV_URL_WINDOWS');
        case 'ANDROID':
          url = dotenv.get('DEV_URL_ANDROID');
        case 'PROD':
          url = dotenv.get('DEV_URL_PROD');
        default:
          throw Exception();
      }
    } catch (e) {
      throw Exception('Error loading environment variables');
    }
  }
}
