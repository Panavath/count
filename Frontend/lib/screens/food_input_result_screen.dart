import 'dart:async';

import 'package:count_frontend/api/back_end_api.dart';
import 'package:count_frontend/dto/search_dto.dart';
import 'package:count_frontend/enums/screen_types.dart';
import 'package:count_frontend/models/scanned_food.dart';
import 'package:count_frontend/models/search_result.dart';
import 'package:count_frontend/providers/async_value.dart';
import 'package:count_frontend/providers/user_data_provider.dart';
import 'package:count_frontend/utility/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResultsScreen extends StatefulWidget {
  final List<ScannedFood> results;
  final ResultScreenType screenType;

  const ResultsScreen(
      {super.key, required this.results, required this.screenType});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  late List<ScannedFood> foodList;
  Set<ScannedFood> selectedItems = {}; // Stores selected food data

  @override
  void initState() {
    updateState();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ResultsScreen oldWidget) {
    updateState();
    super.didUpdateWidget(oldWidget);
  }

  void updateState() {

    foodList = [...widget.results];

    if (widget.screenType == ResultScreenType.manual) {
      Future.delayed(const Duration(milliseconds: 200), () {
      searchFood();
    });
    }
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

  @override
  void dispose() {
    foodSearchController.dispose();
    foodNameController.dispose();
    super.dispose();
  }

  final TextEditingController foodSearchController = TextEditingController();

  void searchFood() async {
    foodSearchController.text = '';
    ScannedFood? newFood = await showDialog<ScannedFood>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Search Food',
            textAlign: TextAlign.center,
          ),
          content: SearchWidget(
            foodSearchController: foodSearchController,
          ),
        );
      },
    );

    if (newFood != null) {
      foodList.remove(newFood);
      foodList.add(newFood);
      selectedItems.add(newFood);
      setState(() {});
    }
  }

  final TextEditingController foodNameController = TextEditingController();
  // Show dialog for food name and meal type input
  Future<void> _showFoodInputDialog() async {
    foodNameController.text = '';
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
                    decoration: const InputDecoration(labelText: 'Meal Name'),
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
    String title;
    String emptyMessage;
    switch (widget.screenType) {
      case ResultScreenType.scan:
        title = "Scan Result";
        emptyMessage = 'No foods found. You can manually add some.';
        break;
      case ResultScreenType.manual:
        title = "Manual Log";
        emptyMessage = 'Add some food to be logged.';
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: foodList.isEmpty
                  ? Center(child: Text(emptyMessage))
                  : ListView.builder(
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
                              color: isSelected
                                  ? Colors.greenAccent
                                  : Colors.white,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                  color:
                                      isSelected ? Colors.green : Colors.grey,
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
                  Colors.blue, // Set the background color of the button
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              textStyle:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ), // Show dialog when pressed
            child: const Text("Add Selected Foods"),
          ),
          const SizedBox(height: 16),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: searchFood,
        backgroundColor: Colors.grey.shade200,
        child: const Icon(Icons.search),
      ),
    );
  }
}

class SearchWidget extends StatefulWidget {
  const SearchWidget({
    super.key,
    required this.foodSearchController,
  });

  final TextEditingController foodSearchController;

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  AsyncValue<List<SearchResult>> searchResult = AsyncValue.empty();

  void search(String query) async {
    setState(() {
      searchResult = AsyncValue.loading();
    });
    try {
      List<SearchResult> results = await BackendApi.search(query);
      if (results.isEmpty) {
        searchResult = AsyncValue.empty();
      } else {
        searchResult = AsyncValue.success(results);
      }
    } catch (e) {
      searchResult = AsyncValue.error(e);
    }
    setState(() {});
  }

  Timer? timer;

  void onChanged(String text) {
    if (text.isEmpty) {
      return;
    }
    if (timer?.isActive ?? false) {
      timer!.cancel();
    }
    timer = Timer(const Duration(milliseconds: 500), () => search(text));
  }

  Widget buildResults(BuildContext context) {
    switch (searchResult.state) {
      case AsyncValueState.none:
        return const Text('Start searching');

      case AsyncValueState.loading:
        return const Text('Searching...');
      case AsyncValueState.error:
        return const Text('Error searching for foods.');
      case AsyncValueState.success:
        List<SearchResult> results = searchResult.data!;
        return Column(
          children: List.generate(
            results.length,
            (index) {
              final result = results[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).pop(SearchDto.toScannedFood(result));
                  },
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(result.description,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    'Calories: ${result.calories} kcal',
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  trailing: const Icon(Icons.more_vert, color: Colors.grey),
                ),
              );
            },
          ),
        );
      case AsyncValueState.empty:
        return const Text('No results.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: widget.foodSearchController,
          decoration: const InputDecoration(labelText: 'Food Name'),
          onChanged: onChanged,
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 200,
          child: SingleChildScrollView(child: buildResults(context)),
        )
      ],
    );
  }
}
