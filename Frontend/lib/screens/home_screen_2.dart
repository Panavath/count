import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import the flutter_svg package

class InfoCard extends StatelessWidget {
  final String label;
  final String value; // Value is now a double
  // final String svgAssetPath;
  final IconData icon;
  final Color iconBackgroundColor;
  final Color valueColor;
  final Color labelColor;
  final double cardWidth;
  final double cardHeight;
  final double iconSize;
  // final String imageUrl;

  InfoCard({
    required this.icon,
    required this.label,
    required this.value, // Now accepts double for value
    // required this.svgAssetPath,
    this.iconBackgroundColor =
        Colors.transparent, // Default icon background color
    this.valueColor = Colors.black,
    this.labelColor = Colors.blueGrey, // Default text color
    this.cardWidth = 200.0, // Default width of the card
    this.cardHeight = 150.0, // Default height of the card
    this.iconSize = 50.0,
    // required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: cardWidth,
      height: cardHeight,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        // border: Border.all(color: Colors.black),
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // SVG Image with a circular background
          // Container(
          //   width: iconSize,
          //   height: iconSize,
          //   decoration: BoxDecoration(
          //     color: iconBackgroundColor,
          //     shape: BoxShape.circle,
          //   ),
          //   child: ClipOval(
          //     child: Image.asset(
          //       imageUrl,
          //       width: iconSize,
          //       height: iconSize,
          //       fit: BoxFit
          //           .contain, // Ensure the SVG scales well inside the circle
          //     ),
          //   ),
          // ),
          Container(
            width: iconSize,
            height: iconSize,
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon, // Use the icon passed into the widget
              size: iconSize * 0.6, // Icon size based on the container size
              color: Colors.black,
            ),
            // child: ClipOval(
            //   child: SvgPicture.asset(
            //     svgAssetPath, // Use your SVG asset here
            //     width: iconSize,
            //     height: iconSize,
            //     fit: BoxFit
            //         .contain, // Ensure the SVG scales well inside the circle
            //   ),
            // ),
          ),
          SizedBox(width: 16),
          // Column to hold the label and value
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: valueColor,
                ),
              ),
              SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: labelColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class InfoCardSmall extends StatelessWidget {
  final String label;
  final String value; // Value is now a double
  // final String svgAssetPath;
  final IconData icon;
  final Color iconBackgroundColor;
  final Color valueColor;
  final Color labelColor;
  final double cardWidth;
  final double cardHeight;
  final double iconSize;
  // final String imageUrl;

  InfoCardSmall({
    required this.icon,
    required this.label,
    required this.value, // Now accepts double for value
    // required this.svgAssetPath,
    this.iconBackgroundColor =
        Colors.transparent, // Default icon background color
    this.valueColor = Colors.black,
    this.labelColor = Colors.blueGrey, // Default text color
    this.cardWidth = 200.0, // Default width of the card
    this.cardHeight = 150.0, // Default height of the card
    this.iconSize = 50.0,
    // required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: cardWidth,
      height: cardHeight,
      padding: const EdgeInsets.all(16.0),
      decoration:BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon with a circular background
          Container(
            width: iconSize,
            height: iconSize,
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon, // Use the icon passed into the widget
              size: iconSize * 0.6, // Icon size based on the container size
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8), // Correct vertical spacing

          // Column to hold the label and value
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value, // Display the dynamic value
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: valueColor,
                ),
              ),
              SizedBox(height: 8),
              Text(
                label, // Display the label
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: labelColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
