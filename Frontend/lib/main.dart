import 'package:count_frontend/enums/screen_types.dart';
import 'package:count_frontend/screens/food_input_result_screen.dart';
import 'package:count_frontend/screens/goal_settings_screen.dart';
import 'package:count_frontend/screens/scan_screen/scan_food_input.dart';
import 'package:count_frontend/utility/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart'; // Import your HomeScreen
import 'providers/user_data_provider.dart'; // Import the SelectedFoodProvider

void main() async {
  await dotenv.load(fileName: 'assets/.env');
  AppConfig.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserDataProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Food Selection App',
        initialRoute: '/signup',
        routes: {
          '/signup': (context) => GoalSettingScreen(),
          '/': (context) => const HomeScreen(),
          '/results': (context) => const ResultsScreen(
              results: [], screenType: ResultScreenType.manual),
          '/scan': (context) => const ScanFoodScreen(),
        },
      ),
    );
  }
}
