import 'package:count_frontend/screens/food_input_result_screen.dart';
import 'package:count_frontend/screens/scan_screen/scan_food_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';  // Import your HomeScreen
import 'providers/user_data_provider.dart';  // Import the SelectedFoodProvider

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserDataProvider(),  // Provide the SelectedFoodProvider here
      child: MaterialApp(
        title: 'Food Selection App',
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(),
          '/results': (context) => ResultsScreen(results: []),
          '/scan': (context) => ScanFoodScreen(),  // Ensure that you have data here
        },
      ),
    );
  }
}
