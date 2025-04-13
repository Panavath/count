import 'package:count_frontend/models/food_log.dart';
import 'package:count_frontend/screens/date_label.dart';
import 'package:count_frontend/screens/home_screen_2.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart'; // Import your custom icons
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:count_frontend/models/user.dart';
import 'package:count_frontend/providers/async_value.dart';
import 'package:count_frontend/providers/user_data_provider.dart'; // Import the state management class

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void register(context) async {
    print("User is not registered. Navigating to Register Screen.");
    // Navigate to Register Screen
    Navigator.pushNamed(context, '/signup');
  }

  Widget _buildDivider() {
    return const Divider(color: Colors.grey, thickness: 1, height: 20, indent: 30, endIndent: 30);
  }

  Widget buildCardWithBorder({
    required String label,
    required double currentValue,
    required double targetValue,
    required IconData icon,
    required Color iconBackgroundColor,
    required double iconSize,
    required double cardWidth,
    required double cardHeight,
    required Color borderColor,
    required Color progressColor,
    required Color iconColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: borderColor,
          width: 10,
        ),
      ),
      child: CompactProgressCard(
        
        iconColor: iconColor,
        progressColor: progressColor,
        label: label,
        icon: icon,
        currentValue: currentValue, 
        targetValue: targetValue,
        
      ),
    );
  }

  Map<String, List<FoodLog>> groupFoodLogsByDate(List<FoodLog> foodLogs) {
    Map<String, List<FoodLog>> groupedLogs = {};

    if (foodLogs.isEmpty) {
      return groupedLogs;  // Return an empty map if no logs are present
    }

    for (var log in foodLogs) {
      String dateLabel = formatDate(log.date); // Format the date
      groupedLogs.putIfAbsent(dateLabel, () => []).add(log);
    }

    return groupedLogs;
  }

  String formatDate(DateTime dateTime) {
    final DateFormat formatter = DateFormat('MMMM dd, yyyy');
    return formatter.format(dateTime);
  }

  Widget buildBody(BuildContext context, UserDataProvider provider) {
    switch (provider.currentUser.state) {
      case AsyncValueState.none:
        provider.logIn();
        return const Center(child: Text('Loading user data...'));

      case AsyncValueState.loading:
        return const Center(child: Text('Loading user data...'));

      case AsyncValueState.error:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('No user data found'),
              ElevatedButton(
                onPressed: () {
                  register(context);
                },
                child: const Text('Re-Register'),
              ),
            ],
          ),
        );

      case AsyncValueState.success:
        User user = provider.currentUser.data!; // Get the current user data

        // Check if the user's foodLogs are not null and not empty
        final foodLogs = user.foodLogs ?? [];
        final groupedLogs = groupFoodLogsByDate(foodLogs);

        // Safely calculate totals with null checks
        double totalCalories = FoodLog.getTotalCalories(foodLogs);
        double totalProtein = FoodLog.getTotalProtein(foodLogs);
        double totalFat = FoodLog.getTotalFat(foodLogs);
        double totalCarbs = FoodLog.getTotalCarb(foodLogs);

        return Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Today",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  color: Colors.blueGrey.shade100,
                  width: 8,
                ),
              ),
              child: ProgressInfoCard(
                progressColor: Colors.orange.shade600,
                
                
                label: 'CALORIES',
                icon: HugeIcons.strokeRoundedFire03,
                cardWidth: MediaQuery.of(context).size.width * 0.85,
                cardHeight: 110,
                currentValue: totalCalories,
                targetValue: user.caloriesGoal ?? 0.0,
              ),
            ),
            _buildDivider(),
            SizedBox(height: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildCardWithBorder(
                  iconColor: Colors.black,
                  label: 'PROTEIN',
                  icon: HugeIcons.strokeRoundedSteak,
                  iconBackgroundColor: Colors.red.shade300,
                  iconSize: 32,
                  cardWidth: MediaQuery.of(context).size.width * 0.25,
                  cardHeight: 140,
                  borderColor: Colors.blueGrey.shade100, 
                  currentValue: totalProtein, 
                  targetValue: user.proteinGoal ?? 0.0, 
                  progressColor: Colors.red,
                ),
                buildCardWithBorder(
                  iconColor: Colors.black,
                  label: 'CARBS',
                  icon: HugeIcons.strokeRoundedRiceBowl01,
                  iconBackgroundColor: Colors.green.shade300,
                  iconSize: 32,
                  cardWidth: MediaQuery.of(context).size.width * 0.25,
                  cardHeight: 125,
                  borderColor: Colors.blueGrey.shade100, 
                  currentValue: totalCarbs, 
                  targetValue: user.carbsGoal ?? 0.0, 
                  progressColor: Colors.green,
                ),
                buildCardWithBorder(
                  iconColor: Colors.black,
                  label: 'FAT',
                  icon: HugeIcons.strokeRoundedFrenchFries01,
                  iconBackgroundColor: Colors.yellow,
                  iconSize: 32,
                  cardWidth: MediaQuery.of(context).size.width * 0.25,
                  cardHeight: 125,
                  borderColor: Colors.blueGrey.shade100, 
                  currentValue: totalFat, 
                  targetValue: user.fatGoal ?? 0.0, 
                  progressColor: Colors.yellow,
                ),
              ],
            ),
            _buildDivider(),
            // Check if groupedLogs is not empty before building the list
            if (groupedLogs.isNotEmpty)
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: groupedLogs.length,
                itemBuilder: (context, index) {
                  String dateLabel = groupedLogs.keys.elementAt(index);
                  List<FoodLog> logsForDate = groupedLogs[dateLabel]!;
                  return DateLog(
                    dateLabel: dateLabel,
                    logsForDate: logsForDate,
                  );
                },
              )
            else
              const Center(child: Text("No logs available for today.")),
          ],
        );

      case AsyncValueState.empty:
        return Center(
          child: ElevatedButton(
            onPressed: () {
              register(context);
            },
            child: const Text('Register'),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    UserDataProvider provider = context.watch<UserDataProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(
                'assets/icon/Count.png',
                fit: BoxFit.fill,
                height: 30,
              ),
            ),
            const SizedBox(width: 20),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: buildBody(context, provider),
          ),
        ),
      ),
      floatingActionButton:
          provider.currentUser.state == AsyncValueState.success
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FloatingActionButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/scan');
                      },
                      backgroundColor: Colors.blue.shade300,
                      heroTag: null,
                      child: const Icon(Icons.camera_alt),
                    ),
                  ],
                )
              : null,
    );
  }
}
