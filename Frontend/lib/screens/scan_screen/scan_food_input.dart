import 'dart:io';
import 'package:count_frontend/enums/screen_types.dart';
import 'package:count_frontend/screens/food_input_result_screen.dart';
import 'package:count_frontend/screens/scan_screen/image_picking_function.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/utility/app_theme.dart';

class ScanFoodScreen extends StatefulWidget {
  const ScanFoodScreen({super.key});

  @override
  State<ScanFoodScreen> createState() => _ScanFoodScreenState();
}

class _ScanFoodScreenState extends State<ScanFoodScreen> {
  File? _image;
  bool _isImageCaptured = false;

  // This function is responsible for selecting an image
Future<void> _pickImage() async {
  try {
    File? selectedImage = await ImagePickerHelper.pickImageAndUpload(context);
    if (selectedImage != null) {
      setState(() {
        _image = selectedImage;
        _isImageCaptured = true;
      });
    }
  } catch (e) {
    // Handle the 500 error specifically
    if (e is DioException && e.response?.statusCode == 500) {
      _showDetectionFailedDialog();
    } else {
      // Handle other errors
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred while processing the image')),
      );
    }
  }
}

void _showDetectionFailedDialog() {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Detection Failed'),
      content: const Text('The image couldn\'t be detected. Please try again or enter manually.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Try Again'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close the dialog
            ResultsScreen(
              results: [], screenType: ResultScreenType.manual);
          },
          child: const Text('Enter Manually'),
        ),
      ],
    ),
  );
}

  // This function will handle the image after user confirms the image
  void _confirmImage() {
    // Placeholder for sending image to backend or saving it
    print("Confirmed image: ${_image?.path}");

    // After confirmation, reset the image or move to next step
    setState(() {
      _isImageCaptured = false; // Reset after confirmation
    });

    Navigator.pop(context); // Navigate back after confirmation (or proceed as needed)
  }

  // This function will allow the user to discard the picked image
  void _cancelImage() {
    setState(() {
      _image = null;  // Reset the image
      _isImageCaptured = false; // Reset the captured status
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      
      backgroundColor: Colors.white,
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Meal Scan', style: AppFonts.heading),
        backgroundColor: AppColors.primaryBlue,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.question_circle, color: Colors.white),
          onPressed: () {
            print("Help clicked");
          },
        ),
      ),
      child: GestureDetector(
        onTap: _pickImage, // Trigger image picker on tapping anywhere in the body
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center the content vertically
          children: [
            Expanded(
              child: Center(
                child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.camera_fill, size: 100, color: Colors.grey),
                          SizedBox(height: 20),
                          Text(
                            "Tap here to capture an image",
                            style: AppFonts.body,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )
                   
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(home: ScanFoodScreen()));
}
