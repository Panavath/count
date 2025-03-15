import 'package:count_frontend/screens/food_input_result_screen.dart';
import 'package:count_frontend/utility/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FoodInputScreen extends StatefulWidget {
  @override
  _FoodInputScreenState createState() => _FoodInputScreenState();
}

class _FoodInputScreenState extends State<FoodInputScreen> {
  final List<Map<String, dynamic>> _ingredients = [];
  final TextEditingController _inputController = TextEditingController();

  final List<Map<String, dynamic>> _mockResults = [
    {'name': 'Apple', 'calories': 52, 'protein': 0.3, 'carbs': 14, 'fat': 0.2},
    {'name': 'Banana', 'calories': 89, 'protein': 1.1, 'carbs': 23, 'fat': 0.3},
    {
      'name': 'Chicken Breast',
      'calories': 165,
      'protein': 31,
      'carbs': 0,
      'fat': 3.6
    },
  ];

  void _addIngredient() {
    if (_inputController.text.isNotEmpty) {
      final parts = _inputController.text.split(',');
      if (parts.length == 2) {
        setState(() {
          _ingredients.add({
            'name': parts[0].trim(),
            'quantity': double.tryParse(parts[1].trim()) ?? 0.0,
          });
          _inputController.clear();
        });
      }
    }
  }

  void _showResultsHandler() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultsScreen(results: _mockResults),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Input', style: AppFonts.heading),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: TextField(
                controller: _inputController,
                decoration: InputDecoration(
                  hintText: 'Enter ingredient, quantity (e.g., Apple, 100)',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(24),
                ),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _addIngredient(),
                style: AppFonts.body,
              ),
            ),
            SizedBox(height: 20),
            AppButton.fullWidthButton(
              text: "Enter",
              onPressed: _showResultsHandler,
            ),
          ],
        ),
      ),
    );
  }
}
