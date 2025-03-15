import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'package:image/image.dart' as img;
import 'widgets/result_display.dart';

class ImagePoseDetector extends StatefulWidget {
  @override
  _ImagePoseDetectorState createState() => _ImagePoseDetectorState();
}

class _ImagePoseDetectorState extends State<ImagePoseDetector> {
  File? _selectedImage;
  tfl.Interpreter? _interpreter;
  String _detectedPose = "";
  double _accuracy = 0.0;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  /// ✅ Load TensorFlow Lite Model
  Future<void> _loadModel() async {
    try {
      _interpreter = await tfl.Interpreter.fromAsset("assets/yoga_pose_classifier.tflite");
      print("✅ Model loaded successfully!");
    } catch (e) {
      print("❌ Error loading model: $e");
    }
  }

  /// 📸 Pick an Image from Gallery
  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    setState(() {
      _selectedImage = File(pickedFile.path);
      _detectedPose = ""; // Clear previous result
      _accuracy = 0.0;
    });

    await _detectPose();
  }

  /// 🔍 Detect Pose with Accuracy Calculation
  Future<void> _detectPose() async {
    if (_selectedImage == null || _interpreter == null) {
      setState(() {
        _detectedPose = "Error in detection";
      });
      return;
    }

    try {
      // ✅ Load and preprocess the image
      List<List<List<List<double>>>> input = await _preprocessImage(_selectedImage!);

      // ✅ Prepare output buffer
      var output = List.filled(6, 0.0).reshape([1, 6]);

      print("✅ Running inference...");
      _interpreter!.run(input, output);

      // ✅ Find the pose with the highest accuracy
      int maxIndex = 0;
      double maxAccuracy = 0.0;
      for (int i = 1; i < output[0].length; i++) {
        if (output[0][i] > maxAccuracy) {
          maxAccuracy = output[0][i];
          maxIndex = i - 1;
        }
      }

      // ✅ Yoga Pose Labels (Ensure these match your model's classes)
      List<String> poseLabels = ["Downdog", "Goddess", "Plank", "Tree", "Warrior2", "UnknownPose"];

      setState(() {
        _detectedPose = poseLabels[maxIndex];
        _accuracy = maxAccuracy; // Use accuracy instead of confidence
      });

      print("🧘 Pose Detected: $_detectedPose (Accuracy: ${(_accuracy * 100).toStringAsFixed(1)}%)");
    } catch (e) {
      setState(() {
        _detectedPose = "Error in detection";
      });
      print("❌ Error detecting pose: $e");
    }
  }

  /// 📏 Preprocess Image for Model (Fixed Issues)
  Future<List<List<List<List<double>>>>> _preprocessImage(File imageFile) async {
    try {
      Uint8List imageBytes = await imageFile.readAsBytes();
      img.Image? image = img.decodeImage(imageBytes);
      if (image == null) throw Exception("Failed to decode image");

      // ✅ Resize image to 224x224
      img.Image resizedImage = img.copyResize(image, width: 224, height: 224);

      // ✅ Convert image to tensor format (4D: [1, 224, 224, 3])
      List<List<List<List<double>>>> input = [
        List.generate(
          224,
          (y) => List.generate(
            224,
            (x) {
              img.Color pixel = resizedImage.getPixel(x, y);
              return [
                pixel.r / 255.0, // Normalize Red
                pixel.g / 255.0, // Normalize Green
                pixel.b / 255.0  // Normalize Blue
              ];
            },
          ),
        )
      ];

      print("✅ Image preprocessing complete!");
      return input;
    } catch (e) {
      print("❌ Error preprocessing image: $e");
      return [
        List.generate(224, (_) => List.generate(224, (_) => List.generate(3, (_) => 0.0))) // Dummy Data
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Yoga Pose Detection")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ✅ Show Image Only If Selected
            if (_selectedImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  _selectedImage!,
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover, // Ensure proper aspect ratio
                ),
              )
            else
              Text("No image selected", style: TextStyle(fontSize: 18)),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: _pickImage,
              child: Text("Pick Image"),
            ),

            SizedBox(height: 20),

            // ✅ Display Pose Detection Result
            ResultDisplay(poseName: _detectedPose, accuracy: _accuracy),
          ],
        ),
      ),
    );
  }
}
