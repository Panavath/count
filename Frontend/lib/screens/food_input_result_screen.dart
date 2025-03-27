import 'package:count_frontend/models/scanned_food.dart';
import 'package:count_frontend/providers/user_data_provider.dart';
import 'package:count_frontend/utility/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResultsScreen extends StatefulWidget {
  final List<ScannedFood> results;

  const ResultsScreen({super.key, required this.results});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  late List<ScannedFood> foodList;
  Set<ScannedFood> selectedItems = {}; // Stores selected food data

  @override
  void initState() {
    super.initState();
    foodList = widget.results;
  }

  void _toggleSelection(ScannedFood food) {
    setState(() {
      if (selectedItems.contains(food)) {
        selectedItems.remove(food);
      } else {
        selectedItems.add(food);
      }
    });
  }

  // Show dialog for food name and meal type input
  Future<void> _showFoodInputDialog() async {
    final TextEditingController foodNameController = TextEditingController();
    String selectedMealType = 'Breakfast'; // Default value for meal type

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              const Text('Enter Food Information', textAlign: TextAlign.center),
          content: StatefulBuilder(
            builder: (BuildContext context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: foodNameController,
                    decoration: const InputDecoration(labelText: 'Food Name'),
                  ),
                  const SizedBox(height: 10),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: selectedMealType,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedMealType =
                            newValue ?? 'Breakfast'; // Update selectedMealType
                      });
                    },
                    items: <String>['Breakfast', 'Lunch', 'Dinner', 'Snack']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              );
            },
          ),
          actions: <Widget>[
            AppButton.primaryButton(
              onPressed: () {
                String foodName = foodNameController.text.isNotEmpty
                    ? foodNameController.text
                    : 'Unknown Food';

                List<ScannedFood> selectedFoods = selectedItems.toList();

                // Send the selected foods to the backend via UserDataProvider
                Provider.of<UserDataProvider>(context, listen: false).newLog(
                    name: foodName,
                    date: DateTime.now(),
                    mealTypeString: selectedMealType,
                    foods: selectedFoods);

                // Close the dialog
                Navigator.of(context).pop();
                // Navigate back to home screen after saving
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
              text: 'Save',
            ),
            AppButton.secondaryButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                text: 'Cancel'),
          ],
        );
      },
    );
  }

  // Add result when "Add Selected Foods" is pressed
  void _addResult() {
    if (selectedItems.isEmpty) {
      // If no food is selected, show a warning message
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please select some foods first!'),
      ));
      return;
    }

    // Show dialog for user to enter food name and meal type
    _showFoodInputDialog();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Results', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: foodList.length,
                itemBuilder: (context, index) {
                  final result = foodList[index];
                  final isSelected = selectedItems.contains(result);

                  return GestureDetector(
                    onTap: () => _toggleSelection(result),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.greenAccent : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(result.className,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 5),
                                Text("Calories: ${result.calories} kcal"),
                                Text("Protein: ${result.proteinG} g"),
                                Text("Carbs: ${result.carbsG} g"),
                                Text("Fat: ${result.fatG} g"),
                              ],
                            ),
                          ),
                          Icon(
                            isSelected
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: isSelected ? Colors.green : Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _addResult,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  Colors.green, // Set the background color of the button
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              textStyle:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ), // Show dialog when pressed
            child: const Text("Add Selected Foods"),
          ),
        ],
      ),
    );
  }
}
