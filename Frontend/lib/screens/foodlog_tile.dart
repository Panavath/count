import 'package:flutter/material.dart';
import 'package:count_frontend/models/food_log.dart'; // Import your FoodLog model

class FoodLogCard extends StatefulWidget {
  final FoodLog foodLog;

  const FoodLogCard({required this.foodLog});

  @override
  _FoodLogCardState createState() => _FoodLogCardState();
}

class _FoodLogCardState extends State<FoodLogCard> {
  bool _isExpanded = false; 
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent, 
          borderRadius: BorderRadius.circular(32), 
          border: Border.all(
            color: Colors.blueGrey.shade100,
            width: 8, 
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded; 
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.foodLog.name,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                       
                        Text(
                          '${widget.foodLog.mealType.toString().split('.').last[0].toUpperCase() + widget.foodLog.mealType.toString().split('.').last.substring(1)}',
                          style: const TextStyle(
                              fontSize: 14,
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  
                    Row(
                      children: [
                        Text(
                          '${widget.foodLog.totalCalories.toStringAsFixed(1)} kcal',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(width: 8),
                       
                        Icon(
                          _isExpanded
                              ? Icons.expand_less
                              : Icons.expand_more,
                          color: Colors.blueGrey,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),  
              if (_isExpanded) ...[  
                Text(
                  'Protein: ${widget.foodLog.totalProtein.toStringAsFixed(1)} g',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),       
                Text(
                  'Carbs: ${widget.foodLog.totalCarbs.toStringAsFixed(1)} g',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Fat: ${widget.foodLog.totalFat.toStringAsFixed(1)} g',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
