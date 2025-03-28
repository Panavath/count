import 'package:count_frontend/models/user.dart';
import 'package:count_frontend/providers/async_value.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_data_provider.dart'; // Import the state management class

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void register(context) async {
    showModalBottomSheet(
        context: context, builder: (context) => _RegisterModal());
  }

  Widget buildBody(BuildContext context, UserDataProvider provider) {
    switch (provider.currentUser.state) {
      case AsyncValueState.none:
        provider.logIn();
        return const Center(
          child: Text('Loading user data...'),
        );
      case AsyncValueState.loading:
        return const Center(
          child: Text('Loading user data...'),
        );
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
              )
            ],
          ),
        );
      case AsyncValueState.success:
        return ListView.builder(
            itemCount: provider.currentUser.data!.foodLogs.length,
            itemBuilder: (context, index) {
              User user = provider.currentUser.data!;
              final foodLog = user.foodLogs[index];

              final foodName = foodLog.name;
              final foodCalories = foodLog.totalCalories;
              final foodProtein = foodLog.totalProtein;
              final foodCarbs = foodLog.totalCarbs;
              final foodFat = foodLog.totalFat;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                elevation: 5, // Enhanced elevation for better shadow effect
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  // leading: CircleAvatar(
                  //   backgroundImage: provider.imagePath != null
                  //       ? FileImage(File(provider
                  //           .imagePath!)) // Use image path from the provider
                  //       : const AssetImage('assets/default_image.png')
                  //           as ImageProvider,
                  //   radius: 30,
                  // ),
                  title: Text(foodName,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    'Calories: $foodCalories kcal\n'
                    'Protein: ${foodProtein}g\n'
                    'Carbs: ${foodCarbs}g\n'
                    'Fat: ${foodFat}g',
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  trailing: const Icon(Icons.more_vert, color: Colors.grey),
                ),
              );
            });
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
        title: const Text('Food Log',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        elevation: 5,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Search functionality can be added here
              debugPrint("Search clicked");
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: buildBody(context, provider),
      ),
      floatingActionButton:
          provider.currentUser.state == AsyncValueState.success
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Add the button for navigating to the ResultsScreen
                    FloatingActionButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/results');
                      },
                      backgroundColor: Colors.green,
                      heroTag: null,
                      child: const Icon(
                          Icons.add), // Required to avoid duplicate hero tags
                    ),
                    const SizedBox(height: 16),
                    // Add the button for navigating to the ScanScreen
                    FloatingActionButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/scan');
                      },
                      backgroundColor: Colors.blueAccent,
                      heroTag: null,
                      child: const Icon(Icons
                          .camera_alt), // Required to avoid duplicate hero tags
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
              )
            ],
          )
        ],
      ),
    );
  }
}
