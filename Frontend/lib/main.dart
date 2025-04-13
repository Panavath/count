import 'package:count_frontend/enums/screen_types.dart';
import 'package:count_frontend/screens/food_input_result_screen.dart';
import 'package:count_frontend/screens/register_screen.dart';
import 'package:count_frontend/screens/scan_screen/scan_food_input.dart';
import 'package:count_frontend/screens/user_settings_screen.dart';
import 'package:count_frontend/utility/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hugeicons/hugeicons.dart';
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
          '/signup': (context) => RegisterScreen(),
          // '/': (context) => const HomeScreen(),k;
          '/': (context) => const BottomNavBarScreen(),
          '/results': (context) => const ResultsScreen(
              results: [], screenType: ResultScreenType.manual),
          '/scan': (context) => const ScanFoodScreen(),
        },
      ),
    );
  }
}

class BottomNavBarScreen extends StatefulWidget {
  const BottomNavBarScreen({Key? key}) : super(key: key);

  @override
  _BottomNavBarScreenState createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends State<BottomNavBarScreen> {
  int _currentIndex = 0;

  // List of screens for bottom navigation
  final List<Widget> _screens = [
    const HomeScreen(), // Home Screen
    // const ScanFoodScreen(), 
    const ResultsScreen(results: [], screenType: ResultScreenType.manual),
    const SettingsScreen(), // Results Screen
  ];

  void toHomeScreen() {
    setState(() {
      _currentIndex = 0;
    });
  }

  // Method to handle the screen switching
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // Body is the current screen based on index
      body: _screens[_currentIndex],

      // BottomNavigationBar is used for switching between the screens
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _currentIndex, // Set the current selected index
        onTap: onTabTapped, // Switch screen when a tab is tapped
        items: const [
          BottomNavigationBarItem(
            icon: Icon(HugeIcons.strokeRoundedHome10),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(HugeIcons.strokeRoundedAddCircle),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(HugeIcons.strokeRoundedUserSettings01),
            label: '',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.settings),
          //   label: 'settings',
          // ),
        ],
      ),
    );
  }
}
