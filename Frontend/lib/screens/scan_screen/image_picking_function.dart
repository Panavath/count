import 'package:count_frontend/api/back_end_api.dart';
import 'package:count_frontend/enums/screen_types.dart';
import 'package:count_frontend/models/scanned_food.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../food_input_result_screen.dart';

class ImagePickerHelper {
  /// Returns the selected image file & navigates to ResultsScreen
  static Future<File?> pickImageAndUpload(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    File? imageFile;

    File? selectedFile = await showCupertinoModalPopup<File?>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: const Text('Select Image Source'),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () async {
                await _requestPermission(Permission.camera);
                final pickedFile = await _picker.pickImage(source: ImageSource.camera);
                Navigator.pop(context, pickedFile != null ? File(pickedFile.path) : null);
              },
              child: const Text('Take Photo'),
            ),
            CupertinoActionSheetAction(
              onPressed: () async {
                await _requestPermission(Permission.photos);
                final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                Navigator.pop(context, pickedFile != null ? File(pickedFile.path) : null);
              },
              child: const Text('Choose from Gallery'),
            ),
            CupertinoActionSheetAction(
              onPressed: () async {
                await _requestPermission(Permission.storage);
                FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
                Navigator.pop(context, result != null ? File(result.files.single.path!) : null);
              },
              child: const Text('Pick a File'),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            isDestructiveAction: true,
            child: const Text('Cancel'),
          ),
        );
      },
    );

    if (selectedFile != null) {
      imageFile = selectedFile;

      // Show image preview before confirming
      bool? confirm = await _showImagePreview(context, imageFile);

      if (confirm != null && confirm) {
        try {
          print("Sending image to backend...");

          // Upload the image and get food scan results
          List<ScannedFood>? foodResults = await BackendApi.scanImage(imageFile);
          print(foodResults);

          if (foodResults != null) {
            print("Food picture successfully sent to backend");

            // Navigate to ResultsScreen with results
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResultsScreen(results: foodResults, screenType: ResultScreenType.scan),
              ),
            );
          } else {
            print("Food picture was not sent");
          }
        } on DioException catch (e) {
          // Handle Dio errors (including 500 errors)
          print("Backend error: ${e.message}");
          
          if (e.response?.statusCode == 500) {
            _showDetectionFailedDialog(context);
          } else {
            _showErrorDialog(context, "Failed to process image. Please try again.");
          }
        } catch (e) {
          print("Unexpected error: $e");
          _showErrorDialog(context, "An unexpected error occurred.");
        }
      } else {
        print("Image discarded by user");
      }

      return imageFile; // Return the image for further processing
    }

    print("No image selected");
    return null;
  }

  static void _showDetectionFailedDialog(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Detection Failed'),
        content: const Text('The image couldn\'t be detected. Please try again or enter manually.'),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('Try Again'),
          ),
          CupertinoDialogAction(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
              // Add your manual entry navigation here
              // Navigator.push(context, MaterialPageRoute(builder: (context) => ManualEntryScreen()));
            },
            child: const Text('Enter Manually'),
          ),
        ],
      ),
    );
  }

  static void _showErrorDialog(BuildContext context, String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Function to show the image preview and ask for confirmation
  static Future<bool?> _showImagePreview(BuildContext context, File imageFile) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Confirm Image'),
          content: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: FileImage(imageFile),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Do you want to proceed with this image?'),
            ],
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Discard'),
            ),
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  static Future<void> _requestPermission(Permission permission) async {
    if (await permission.isDenied || await permission.isPermanentlyDenied) {
      await permission.request();
    }
    debugPrint("Permission status for $permission: ${await permission.status}");
  }
}