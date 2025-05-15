// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

void main() {
  runApp(const JaundiceDiagnosisApp());
}

class JaundiceDiagnosisApp extends StatelessWidget {
  const JaundiceDiagnosisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jaundice Diagnosis',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          color: Colors.white, // Background is white
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Jaundice Diagnosis',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Text color is black
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Detect jaundice in infants using camera.',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black, // Text color is black
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Image.asset(
              'assets/images/baby_icon.jpeg', // Add your image asset here
              height: 150,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TakePhotoScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Button background is blue
                foregroundColor: Colors.white, // Button text is white
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}

class TakePhotoScreen extends StatefulWidget {
  const TakePhotoScreen({super.key});

  @override
  _TakePhotoScreenState createState() => _TakePhotoScreenState();
}

class _TakePhotoScreenState extends State<TakePhotoScreen> {
  Future<void> _pickImage(ImageSource source) async {
    if (kIsWeb || !Platform.isIOS && !Platform.isAndroid) {
      print('Camera not supported on this platform.');
      return;
    }

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      // Handle the selected image (e.g., save it or process it)
      print('Image selected: ${pickedFile.path}');
    } else {
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          color: Colors.white, // Background is white
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Take a Photo',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Text color is black
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Center the infant\'s face in the frame and ensure good lighting!',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black, // Text color is black
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _pickImage(ImageSource.camera), // Open the camera
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Button background is blue
                    foregroundColor: Colors.white, // Button text is white
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                  child: const Text('Take Photo'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _pickImage(ImageSource.gallery), // Open the gallery
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Button background is blue
                    foregroundColor: Colors.white, // Button text is white
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                  child: const Text('Choose from Library'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ResultScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Button background is blue
                foregroundColor: Colors.white, // Button text is white
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          color: Colors.white, // Change background to white
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Result',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Text color is black
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Jaundice Detected',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Text color is black
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'The infant shows signs of jaundice. Seek medical advice for further evaluation and care.',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black, // Text color is black
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Button background is blue
                foregroundColor: Colors.white, // Button text is white
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Done'),
            ),
          ],
        ),
      ),
    );
  }
}

class EnterDetailsScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();

  EnterDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          color: Colors.white, // Background is white
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Enter Details',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Text color is black
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                labelStyle: TextStyle(color: Colors.black), // Label color is black
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black), // Border color is black
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black), // Border color is black
                ),
              ),
              style: const TextStyle(color: Colors.black), // Input text color is black
            ),
            const SizedBox(height: 20),
            TextField(
              controller: dobController,
              decoration: const InputDecoration(
                labelText: 'Date of Birth',
                labelStyle: TextStyle(color: Colors.black), // Label color is black
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black), // Border color is black
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black), // Border color is black
                ),
              ),
              style: const TextStyle(color: Colors.black), // Input text color is black
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle submit action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Button background is blue
                  foregroundColor: Colors.white, // Button text is white
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// iOS-specific permissions
const String cameraUsageDescription = '<key>NSCameraUsageDescription</key>\n<string>We need access to your camera to take photos.</string>';
const String photoLibraryUsageDescription = '<key>NSPhotoLibraryUsageDescription</key>\n<string>We need access to your photo library to select photos.</string>';
// Remove invalid iOS-specific configuration from Dart code.
// Add these keys to the iOS Info.plist file instead.
