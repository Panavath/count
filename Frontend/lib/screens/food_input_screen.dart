import 'package:count_frontend/dto/food_log_dto.dart';
import 'package:count_frontend/models/scanned_food.dart';
import 'package:count_frontend/screens/food_input_result_screen.dart';
import 'package:count_frontend/utility/app_theme.dart';
import 'package:flutter/material.dart';

class FoodInputScreen extends StatefulWidget {
  const FoodInputScreen({super.key});

  @override
  State<FoodInputScreen> createState() => _FoodInputScreenState();
}

class _FoodInputScreenState extends State<FoodInputScreen> {
  final List<Map<String, dynamic>> _ingredients = [];
  final TextEditingController _inputController = TextEditingController();

  final List<ScannedFood> _mockResults = [
    ScannedFoodDto.fromJson({
      'class_name': 'Apple',
      'description': 'apple',
      'serving_size': 1.0,
      'confidence': 0.8,
      'calories': 52,
      'protein_g': 0.3,
      'carbs_g': 14,
      'fat_g': 0.2
    }),
    ScannedFoodDto.fromJson({
      'class_name': 'Banana',
      'description': 'banana',
      'serving_size': 1.0,
      'confidence': 0.8,
      'calories': 89,
      'protein': 1.1,
      'carbs': 23,
      'fat': 0.3
    }),
    ScannedFoodDto.fromJson({
      'class_name': 'Chicken Breast',
      'description': 'chicken',
      'serving_size': 1.0,
      'confidence': 0.8,
      'calories': 165,
      'protein': 31,
      'carbs': 0,
      'fat': 3.6
    }),
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
        title: const Text('Food Input', style: AppFonts.heading),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
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
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: TextField(
                controller: _inputController,
                decoration: const InputDecoration(
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
            const SizedBox(height: 20),
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
