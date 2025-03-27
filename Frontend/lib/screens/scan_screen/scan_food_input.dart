import 'dart:io';
import 'package:count_frontend/screens/scan_screen/image_picking_function.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
import '/utility/app_theme.dart';

class ScanFoodScreen extends StatefulWidget {
  const ScanFoodScreen({super.key});

  @override
  State<ScanFoodScreen> createState() => _ScanFoodScreenState();
}

class _ScanFoodScreenState extends State<ScanFoodScreen> {
  File? _image;
  // final ImagePicker _picker = ImagePicker();
  bool _isImageCaptured = false;

  Future<void> _pickImage() async {
    // Picking image logic using ImagePickerHelper
    File? selectedImage = await ImagePickerHelper.pickImageAndUpload(context);
    if (selectedImage != null) {

      // Additional logic like processing the image
      print("Processing image: ${selectedImage.path}");

      setState(() {
        _image = selectedImage;
        _isImageCaptured = true;
      });
    }
  }

  void _saveImage() {
    // Placeholder for save image functionality
    print("Image saved: ${_image?.path}");

    setState(() {
      _isImageCaptured = false;
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Meal Scan', style: AppFonts.heading),
        backgroundColor: AppColors.primaryBlue,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.back, color: Colors.white),
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
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: _image == null
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(CupertinoIcons.camera_fill, size: 100, color: Colors.grey),
                        SizedBox(height: 20),
                        Text(
                          "Tap the button to capture an image",
                          style: AppFonts.body,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: FileImage(_image!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Tap the button to detect items in your meal",
                          style: AppFonts.body,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CupertinoButton(
              onPressed: _isImageCaptured ? _saveImage : _pickImage,
              color: _isImageCaptured ? CupertinoColors.systemGreen : CupertinoColors.activeBlue,
              borderRadius: BorderRadius.circular(30),
              padding: const EdgeInsets.all(20),
              child: Icon(
                _isImageCaptured ? CupertinoIcons.checkmark_alt : CupertinoIcons.camera_fill,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(home: ScanFoodScreen()));
}
