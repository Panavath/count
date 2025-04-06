import 'package:count_frontend/screens/foodlog_tile.dart';
import 'package:flutter/material.dart';
import 'package:count_frontend/models/food_log.dart'; 


class DateLog extends StatelessWidget {
  final String dateLabel; 
  final List<FoodLog> logsForDate; 

  const DateLog({
    required this.dateLabel,
    required this.logsForDate,
  });
Widget _buildDivider() {
    return const Divider(color: Colors.grey, thickness: 1, height: 20, indent: 30, endIndent: 30,);
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24.0, top: 16),
          child: Text(
            dateLabel,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        _buildDivider(),
        
        ListView.builder(
          shrinkWrap: true, 
          physics: const NeverScrollableScrollPhysics(), 
          itemCount: logsForDate.length,
          itemBuilder: (context, index) {
            return FoodLogCard(foodLog: logsForDate[index]); 
          },
        ),
      ],
    );
  }
}