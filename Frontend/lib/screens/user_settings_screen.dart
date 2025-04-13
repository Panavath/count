import 'package:count_frontend/models/user.dart';
import 'package:count_frontend/providers/async_value.dart';
import 'package:count_frontend/providers/user_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController goalWeightController = TextEditingController();
  final TextEditingController goalCaloriesController = TextEditingController();

  String selectedGender = 'male';
  String selectedActivityLevel = 'moderately_active';
  DateTime selectedDate = DateTime.now();

  @override
  void dispose() {
    weightController.dispose();
    heightController.dispose();
    goalWeightController.dispose();
    goalCaloriesController.dispose();
    super.dispose();
  }

 Future<void> _updateUserData(UserDataProvider provider, User user) async {
    double proteinGoal = (user.caloriesGoal! * 0.30) / 4; // Calculate protein goal
    double carbGoal = (user.caloriesGoal! * 0.40) / 4;   // Calculate carb goal
    double fatGoal = (user.caloriesGoal! * 0.30) / 9;    // Calculate fat goal

    provider.setUserGoal(
      weight: double.tryParse(weightController.text) ?? user.weightKg ?? 0.0,
      height: double.tryParse(heightController.text) ?? user.heightCm ?? 0.0,
      gender: selectedGender,
      activityLevel: selectedActivityLevel,
      dob: selectedDate,
      currentUserId: user.id,
      weightGoal: double.tryParse(goalWeightController.text) ?? user.weightGoal ?? 0.0,
      proteinGoal: proteinGoal,
      carbGoal: carbGoal,
      fatGoal: fatGoal, username: user.username,
    );
  }@override
  Widget build(BuildContext context) {
    final userDataProvider = Provider.of<UserDataProvider>(context);
    final currentUser = userDataProvider.currentUser;

    if (currentUser.state == AsyncValueState.success) {
      final user = currentUser.data!;

      // Initialize controllers if they're empty
      if (weightController.text.isEmpty) weightController.text = user.weightKg?.toString() ?? '';
      if (heightController.text.isEmpty) heightController.text = user.heightCm?.toString() ?? '';
      if (goalWeightController.text.isEmpty) goalWeightController.text = user.weightGoal?.toString() ?? '';
      if (goalCaloriesController.text.isEmpty) goalCaloriesController.text = user.caloriesGoal?.toString() ?? '';

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('User Settings', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage('https://cdn-useast1.kapwing.com/static/templates/crying-cat-meme-template-regular-096fc808.webp'),
                ),
                const SizedBox(height: 20),
                _buildReadOnlyTile('Name', user.username ?? 'Not set'),
                _buildDivider(),
                _buildEditableTile(
                  'Height', 
                  user.heightCm, 
                  heightController, 
                  'Height (cm)', 
                  TextInputType.number,
                  (value) => _updateUserData(userDataProvider, user),
                ),
                _buildDivider(),
                _buildEditableTile(
                  'Weight', 
                  user.weightKg, 
                  weightController, 
                  'Weight (kg)', 
                  TextInputType.number,
                  (value) => _updateUserData(userDataProvider, user),
                ),
                _buildDivider(),
                _buildEditableTile(
                  'Goal Weight', 
                  user.weightGoal, 
                  goalWeightController, 
                  'Goal Weight (kg)', 
                  TextInputType.number,
                  (value) => _updateUserData(userDataProvider, user),
                ),
                _buildDivider(),
                _buildEditableTile(
                  'Maintainance Calories', 
                  user.caloriesGoal, 
                  goalCaloriesController, 
                  'Goal Calories (kcal)', 
                  TextInputType.number,
                  (value) => _updateUserData(userDataProvider, user),
                ),
                _buildDivider(),
                _buildActivityLevelDropdown(userDataProvider, user),
                ElevatedButton(
                  onPressed: () async {
                    await _updateUserData(userDataProvider, user);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Settings confirmed!')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Confirm Settings', 
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildReadOnlyTile(String title, String value) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(value),
    );
  }

  Widget _buildEditableTile(
    String title,
    double? value,
    TextEditingController controller,
    String label,
    TextInputType keyboardType,
    Function(double) onSave,
  ) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
      subtitle: Text(value?.toString() ?? 'Not set'),
      trailing: IconButton(
        icon: const Icon(Icons.edit, color: Colors.blue),
        onPressed: () => _showEditDialog(
          controller,
          label,
          keyboardType,
          value,
          onSave,
        ),
      ),
    );
  }

  Widget _buildActivityLevelDropdown(UserDataProvider provider, User user) {
    return ListTile(
      title: Text('Activity Level', style: const TextStyle(fontWeight: FontWeight.bold)),
      trailing: DropdownButton<String>(
        value: selectedActivityLevel,
        items: const [
          DropdownMenuItem(value: 'sedentary', child: Text('Sedentary')),
          DropdownMenuItem(value: 'lightly_active', child: Text('Lightly Active')),
          DropdownMenuItem(value: 'moderately_active', child: Text('Moderately Active')),
          DropdownMenuItem(value: 'very_active', child: Text('Very Active')),
        ],
        onChanged: (value) {
          if (value != null) {
            setState(() {
              selectedActivityLevel = value;
            });
            _updateUserData(provider, user);
          }
        },
      ),
    );
  }

  Future<void> _showEditDialog(
    TextEditingController controller,
    String label,
    TextInputType keyboardType,
    double? currentValue,
    Function(double) onSave,
  ) async {
    controller.text = currentValue?.toString() ?? '';

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $label'),
        content: TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(labelText: label),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final value = double.tryParse(controller.text);
              if (value != null) {
                onSave(value);
                setState(() {}); // Update UI immediately
              }
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(color: Colors.grey, thickness: 1, height: 5);
  }
}
