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
    showModalBottomSheet(
        context: context, builder: (context) => _RegisterModal());
  }

  Widget buildCardWithBorder({
    required String label,
    required String value,
    required IconData icon,
    required Color iconBackgroundColor,
    required double iconSize,
    required double cardWidth,
    required double cardHeight,
    required Color borderColor,
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
      child: InfoCardSmall(
        label: label,
        iconBackgroundColor: iconBackgroundColor,
        value: value,
        icon: icon,
        iconSize: iconSize,
        cardWidth: cardWidth,
        cardHeight: cardHeight,
      ),
    );
  }

  Map<String, List<FoodLog>> groupFoodLogsByDate(List<FoodLog> foodLogs) {
    Map<String, List<FoodLog>> groupedLogs = {};

    for (var log in foodLogs) {
      String dateLabel =
          formatDate(log.date); // Format the date (use DateFormat as required)
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
        final foodLog = user.foodLogs.isNotEmpty ? user.foodLogs[0] : null;

        final groupedLogs = groupFoodLogsByDate(user.foodLogs);

       double totalCalories = FoodLog.getTotalCalories(user.foodLogs);
       double totalProtein = FoodLog.getTotalProtein(user.foodLogs);
       double totalFat = FoodLog.getTotalFat(user.foodLogs);
       double totalCarbs = FoodLog.getTotalCarb(user.foodLogs);


        return Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Today",
                      textScaler: TextScaler.linear(1),
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.transparent, // Background color of the card
                borderRadius: BorderRadius.circular(32), // Rounded corners
                border: Border.all(
                  color: Colors.blueGrey.shade100,
                  width: 8, // Border width
                ),
              ),
              child: InfoCard(
                label: 'CALORIES',
                iconBackgroundColor: Colors.orange.shade300,
                value: foodLog != null
                    ? "${totalCalories} kcal"
                    : "0 kcal",
                icon: HugeIcons.strokeRoundedFire03,
                iconSize: 100,
                cardWidth: MediaQuery.of(context).size.width * 0.85,
                cardHeight: 110,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Using the new method to create the small cards with borders
                buildCardWithBorder(
                  label: 'PROTEIN',
                  value:"${totalProtein > 0 ? totalProtein.toStringAsFixed(1) : '0'} g",
                  icon: HugeIcons.strokeRoundedSteak,
                  iconBackgroundColor: Colors.red.shade300,
                  iconSize: 32,
                  cardWidth: MediaQuery.of(context).size.width * 0.25,
                  cardHeight: 125,
                  borderColor: Colors.blueGrey.shade100, // Grey border color
                ),
                buildCardWithBorder(
                  label: 'CARBS',
                  value: "${totalCarbs > 0 ? totalCarbs.toStringAsFixed(1) : '0'} g",
                  icon: HugeIcons.strokeRoundedRiceBowl01,
                  iconBackgroundColor: Colors.green.shade300,
                  iconSize: 32,
                  cardWidth: MediaQuery.of(context).size.width * 0.25,
                  cardHeight: 125,
                  borderColor: Colors.blueGrey.shade100, // Grey border color
                ),
                buildCardWithBorder(
                  label: 'FAT',
                  value: "${totalFat > 0 ? totalFat.toStringAsFixed(1) : '0'} g",
                  icon: HugeIcons.strokeRoundedFrenchFries01,
                  iconBackgroundColor: Colors.yellow.shade300,
                  iconSize: 32,
                  cardWidth: MediaQuery.of(context).size.width * 0.25,
                  cardHeight: 125,
                  borderColor: Colors.blueGrey.shade100, // Grey border color
                ),
              ],
            ),
          
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
              ),
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(HugeIcons.strokeRoundedUser), // Left icon
              onPressed: () {
                debugPrint("User clicked");
              },
            ),
            const SizedBox(width: 50),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/icon/Count.png',
                fit: BoxFit.contain,
                height: 50,
              ),
            ),
            const SizedBox(width: 50),
            IconButton(
              highlightColor: Colors.black,
              icon: const Icon(Icons.search, color: Colors.black), // Right icon
              onPressed: () {
                debugPrint("Search clicked");
              },
            ),
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
                        Navigator.pushNamed(context, '/results');
                      },
                      backgroundColor: Colors.blue.shade300,
                      heroTag: null,
                      child: const Icon(Icons.add),
                    ),
                    const SizedBox(height: 16),
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

class _RegisterModal extends StatefulWidget {
  @override
  State<_RegisterModal> createState() => _RegisterModalState();
}

class _RegisterModalState extends State<_RegisterModal> {
  final TextEditingController controller = TextEditingController();

  void onAdd() {
    if (controller.text.isEmpty) return;

    UserDataProvider user = context.read<UserDataProvider>();
    user.signUp(controller.text);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: controller,
            decoration: const InputDecoration(label: Text('Username')),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: 200,
                child: ElevatedButton(
                    onPressed: onAdd, child: const Text('Register')),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
