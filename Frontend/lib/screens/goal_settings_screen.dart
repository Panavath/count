import 'package:count_frontend/providers/async_value.dart';
import 'package:count_frontend/providers/user_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GoalSettingScreen extends StatelessWidget {
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  String selectedGender = 'male'; // Default to male
  String selectedActivityLevel = 'moderately_active'; // Default to moderately active

  @override
  Widget build(BuildContext context) {
    // Retrieve the current user ID from the provider
    final currentUser = Provider.of<UserDataProvider>(context).currentUser;

    // Check if currentUser has data
    if (currentUser.state == AsyncValueState.success) {
      int currentUserId = currentUser.data!.id;

      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            "Set Your Goals",
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo at the top
                Center(
                  child: Image.asset(
                    'assets/icon/Count.png', // Make sure to replace with your logo
                    height: 200,
                    width: 200,
                  ),
                ),
                const SizedBox(height: 10),
                
                // Weight Input Field
                _buildInputField(
                  controller: weightController,
                  label: 'Weight (kg)',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                
                // Height Input Field
                _buildInputField(
                  controller: heightController,
                  label: 'Height (cm)',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                
                // Age Input Field
                _buildInputField(
                  controller: ageController,
                  label: 'Age (years)',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                
                // Gender Dropdown
                _buildDropdown<String>(
                  label: 'Gender',
                  value: selectedGender,
                  items: ['male', 'female'],
                  onChanged: (String? newValue) {
                    selectedGender = newValue!;
                  },
                ),
                const SizedBox(height: 12),
                
                // Activity Level Dropdown
                _buildDropdown<String>(
                  label: 'Activity Level',
                  value: selectedActivityLevel,
                  items: [
                    'sedentary',
                    'lightly_active',
                    'moderately_active',
                    'very_active'
                  ],
                  onChanged: (String? newValue) {
                    selectedActivityLevel = newValue!;
                  },
                ),
                const SizedBox(height: 24),
                
                // Save Goals Button
                ElevatedButton(
                  onPressed: () {
                    double weight = double.tryParse(weightController.text) ?? 0.0;
                    double height = double.tryParse(heightController.text) ?? 0.0;
                    int age = int.tryParse(ageController.text) ?? 0;

                    // Set the user goal using the currentUserId
                    Provider.of<UserDataProvider>(context, listen: false)
                        .setUserGoal(
                          weight: weight,
                          height: height,
                          age: age,
                          gender: selectedGender,
                          activityLevel: selectedActivityLevel,
                          currentUserId: currentUserId,
                        );

                    // Optionally navigate or show feedback
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Goals saved successfully!')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Button color
                    minimumSize: const Size(double.infinity, 50), // Full width button
                  ),
                  child: const Text(
                    'Save Goals',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // If the user data is not loaded, show a loading screen
    return const Center(child: CircularProgressIndicator());
  }

  // Helper method to create the text input fields with labels
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required TextInputType keyboardType,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      keyboardType: keyboardType,
    );
  }

  // Helper method to create dropdowns with labels
  Widget _buildDropdown<T>({
    required String label,
    required T value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      onChanged: onChanged,
      items: items.map<DropdownMenuItem<T>>((T value) {
        return DropdownMenuItem<T>(
          value: value,
          child: Text(value.toString()),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
    );
  }
}
