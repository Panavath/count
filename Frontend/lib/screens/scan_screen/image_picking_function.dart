import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../services/image_service.dart.dart';
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
          title: Text('Select Image Source'),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () async {
                await _requestPermission(Permission.camera);
                final pickedFile = await _picker.pickImage(source: ImageSource.camera);
                Navigator.pop(context, pickedFile != null ? File(pickedFile.path) : null);
              },
              child: Text('Take Photo'),
            ),
            CupertinoActionSheetAction(
              onPressed: () async {
                await _requestPermission(Permission.photos);
                final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                Navigator.pop(context, pickedFile != null ? File(pickedFile.path) : null);
              },
              child: Text('Choose from Gallery'),
            ),
            CupertinoActionSheetAction(
              onPressed: () async {
                await _requestPermission(Permission.storage);
                FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
                Navigator.pop(context, result != null ? File(result.files.single.path!) : null);
              },
              child: Text('Pick a File'),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
            isDestructiveAction: true,
          ),
        );
      },
    );

    if (selectedFile != null) {
      imageFile = selectedFile;

      print("Sending image to backend...");
      
      // Upload the image and get food scan results
      List<Map>? foodResults = await ImageService.uploadImage(imageFile);
      print(foodResults);

      if (foodResults != null) {
        print("Food picture successfully sent to backend");
        
        // Navigate to ResultsScreen with results
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultsScreen(results: foodResults),
          ),
        );
      } else {
        print("Food picture was not sent");
      }

      return imageFile; // Return the image for further processing
    }

    print("No image selected");
    return null;
  }

  static Future<void> _requestPermission(Permission permission) async {
    if (await permission.isDenied || await permission.isPermanentlyDenied) {
      await permission.request();
    }
    debugPrint("Permission status for $permission: ${await permission.status}");
  }
 

}
