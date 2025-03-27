import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_data_provider.dart';  // Import the state management class

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Log',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        elevation: 5,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Search functionality can be added here
              print("Search clicked");
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<UserDataProvider>(
          builder: (context, provider, child) {
            return ListView.builder(
              itemCount: provider.foodHistory.length,
              itemBuilder: (context, index) {
                final foodLog = provider.foodHistory[index];

                // Assuming foodLog['foods'] contains a list of food items
                final food = foodLog['foods']?.first ??
                    {}; // Access the first food item (or empty map if not available)

                // Safely accessing food properties
                final foodName = food['name'] ?? 'Unknown'; // Default to 'Unknown' if null
                final foodCalories = food['calories'] ?? 0.0;
                final foodProtein = food['protein_g'] ?? 0.0;
                final foodCarbs = food['carbs_g'] ?? 0.0;
                final foodFat = food['fat_g'] ?? 0.0;

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  elevation: 5, // Enhanced elevation for better shadow effect
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundImage: provider.imagePath != null
                          ? FileImage(File(provider.imagePath!)) // Use image path from the provider
                          : AssetImage('assets/default_image.png') as ImageProvider,
                      radius: 30,
                    ),
                    title: Text(foodName,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      'Calories: ${foodCalories} kcal\n'
                      'Protein: ${foodProtein}g\n'
                      'Carbs: ${foodCarbs}g\n'
                      'Fat: ${foodFat}g',
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                    trailing: Icon(Icons.more_vert, color: Colors.grey),
                    onTap: () {
                      // Add onTap functionality if needed
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Add the button for navigating to the ResultsScreen
          FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/results');
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.green,
            heroTag: null, // Required to avoid duplicate hero tags
          ),
          SizedBox(height: 16),
          // Add the button for navigating to the ScanScreen
          FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/scan');
            },
            child: Icon(Icons.camera_alt),
            backgroundColor: Colors.blueAccent,
            heroTag: null, // Required to avoid duplicate hero tags
          ),
        ],
      ),
    );
  }
}
