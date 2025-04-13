import 'package:count_frontend/providers/user_data_provider.dart';
import 'package:count_frontend/screens/foodlog_tile.dart';
import 'package:flutter/material.dart';
import 'package:count_frontend/models/food_log.dart';
import 'package:provider/provider.dart';

class DateLog extends StatelessWidget {
  final String dateLabel;
  final List<FoodLog> logsForDate;

  const DateLog({
    required this.dateLabel,
    required this.logsForDate,
  });
  Widget _buildDivider() {
    return const Divider(
      color: Colors.grey,
      thickness: 1,
      height: 20,
      indent: 30,
      endIndent: 30,
    );
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
            return Dismissible(
              key: Key(logsForDate[index]
                  .toString()), // Provide a unique key for each item
              onDismissed: (direction) {
                UserDataProvider provider = Provider.of(context, listen: false);
                provider.deleteLog(logsForDate[index].foodLogId ?? -1);

                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Item dismissed')));
              },
              background: Container(
                  color: Colors.transparent), // Set the background color when swiped
              child: FoodLogCard(
                  foodLog: logsForDate[index]), // Your existing child widget
            );
          },
        ),
      ],
    );
  }
}
