

import 'package:count_frontend/utility/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


void _addResult(){

}
class ResultsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> results;

  const ResultsScreen({Key? key, required this.results}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Results', style: AppFonts.heading),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final result = results[index];
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    padding: EdgeInsets.all(16),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          result['name'],
                          style: AppFonts.subheading,
                        ),
                        SizedBox(height: 5),
                        Text("Calories: ${result['calories']} kcal", style: AppFonts.body),
                        Text("Protein: ${result['protein']}g", style: AppFonts.body),
                        Text("Carbs: ${result['carbs']}g", style: AppFonts.body),
                        Text("Fat: ${result['fat']}g", style: AppFonts.body),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          AppButton.fullWidthButton(
            text: "Add Result",
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}