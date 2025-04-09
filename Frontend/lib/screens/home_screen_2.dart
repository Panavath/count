import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import the flutter_svg package

import 'package:flutter/material.dart';
class ProgressInfoCard extends StatelessWidget {
  final String label;
  final double currentValue;
  final double targetValue;
  final IconData icon;
  final Color iconColor;
  final Color progressColor;
  final Color progressBackgroundColor;
  final Color valueColor;
  final Color labelColor;
  final double cardWidth;
  final double cardHeight;
  final double indicatorSize;

  const ProgressInfoCard({
    Key? key,
    required this.icon,
    required this.label,
    required this.currentValue,
    required this.targetValue,
    this.iconColor = Colors.black,
    this.progressColor = Colors.blue,
    this.progressBackgroundColor = Colors.grey,
    this.valueColor = Colors.black,
    this.labelColor = Colors.blueGrey,
    this.cardWidth = 200.0,
    this.cardHeight = 150.0,
    this.indicatorSize = 80.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double progress = targetValue > 0 
        ? (currentValue / targetValue).clamp(0.0, 1.0).toDouble()
        : 0.0;
    
    final String progressPercentage = (progress * 100).toStringAsFixed(1);

    return Container(
      width: cardWidth,
      height: cardHeight,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        children: [
          // Integrated progress indicator with icon
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: indicatorSize,
                height: indicatorSize,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 6,
                  backgroundColor: progressBackgroundColor.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                ),
              ),
              Container(
                width: indicatorSize * 0.6,  // Slightly larger than icon
                height: indicatorSize * 0.6,
                decoration: BoxDecoration(
                  color: progressColor.withOpacity(0.2),  // Matching small card style
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: indicatorSize * 0.4,  // Adjusted size
                  color: iconColor,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${currentValue.toStringAsFixed(0)} / ${targetValue.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: valueColor,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: labelColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class CompactProgressCard extends StatelessWidget {
  final String label;
  final double currentValue;
  final double targetValue;
  final IconData icon;
  final Color iconColor;
  final Color progressColor;
  final Color valueColor;
  final double size;

  const CompactProgressCard({
    Key? key,
    required this.icon,
    required this.label,
    required this.currentValue,
    required this.targetValue,
    this.iconColor = Colors.black,
    this.progressColor = Colors.blue,
    this.valueColor = Colors.black,
    this.size = 105.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Safe progress calculation with null/zero checks
    final double safeTarget = targetValue > 0 ? targetValue : 1.0;
    final double progress = (currentValue / safeTarget).clamp(0.0, 1.0);
    final String progressPercentage = (progress * 100).toStringAsFixed(0);

    return Container(
      width: size,
      height: size + 10,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: size * 0.6,
                height: size * 0.6,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 4,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                ),
              ),
              Container(
                width: size * 0.3,
                height: size * 0.4,  
                decoration: BoxDecoration(
                  color: progressColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: size * 0.2,
                  color: iconColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Label
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 10,
                color: Colors.blueGrey[600],
              ),
              overflow: TextOverflow.ellipsis, // Prevent text overflow
              maxLines: 1,  // Limit to 1 line
            ),
          ),
          // Current/Target values (optional)
          Flexible(
            child: Text(
              '${currentValue.toStringAsFixed(0)}/${targetValue.toStringAsFixed(0)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.black,
              ),
              overflow: TextOverflow.ellipsis, // Prevent text overflow
              maxLines: 1,  // Limit to 1 line
            ),
          ),
        ],
      ),
    );
  }
}
