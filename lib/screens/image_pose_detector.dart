import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'package:image/image.dart' as img;
import '../widgets/result_display.dart';

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

  // ✅ Debounce Variables
  String _lastDetectedPose = "";
  double _lastAccuracy = 0.0;
  int _frameCount = 0;

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
      _detectedPose = "";
      _accuracy = 0.0;
    });

    await _detectPose();
  }

  /// 🔍 Detect Pose with Optimizations
  Future<void> _detectPose() async {
    if (_selectedImage == null || _interpreter == null) {
      setState(() {
        _detectedPose = "Error in detection";
      });
      return;
    }

    // ✅ Frame Skipping → Runs inference on every 5th frame
    _frameCount++;
    if (_frameCount % 5 != 0) return; 

    try {
      List<List<List<List<double>>>> input = await _preprocessImage(_selectedImage!);
      var output = List.filled(6, 0.0).reshape([1, 6]);

      print("✅ Running inference...");
      _interpreter!.run(input, output);

      int maxIndex = 0;
      double maxAccuracy = 0.0;
      for (int i = 1; i < output[0].length; i++) {
        if (output[0][i] > maxAccuracy) {
          maxAccuracy = output[0][i];
          maxIndex = i - 1;
        }
      }

      List<String> poseLabels = ["Downdog", "Goddess", "Plank", "Tree", "Warrior2", "UnknownPose"];
      String newPose = poseLabels[maxIndex];
      double newAccuracy = maxAccuracy;

      // ✅ Debounce Mechanism → Updates pose only if it changes or accuracy fluctuates by >5%
      if (newPose != _lastDetectedPose || (newAccuracy - _lastAccuracy).abs() > 0.05) {
        setState(() {
          _detectedPose = newPose;
          _accuracy = newAccuracy;
        });

        _lastDetectedPose = newPose;
        _lastAccuracy = newAccuracy;

        print("🧘 Pose Detected: $_detectedPose (Accuracy: ${(_accuracy * 100).toStringAsFixed(1)}%)");
      }
    } catch (e) {
      setState(() {
        _detectedPose = "Error in detection";
      });
      print("❌ Error detecting pose: $e");
    }
  }

  /// 📏 Preprocess Image for Model
  Future<List<List<List<List<double>>>>> _preprocessImage(File imageFile) async {
    try {
      Uint8List imageBytes = await imageFile.readAsBytes();
      img.Image? image = img.decodeImage(imageBytes);
      if (image == null) throw Exception("Failed to decode image");

      img.Image resizedImage = img.copyResize(image, width: 224, height: 224);

      List<List<List<List<double>>>> input = [
        List.generate(
          224,
          (y) => List.generate(
            224,
            (x) {
              img.Color pixel = resizedImage.getPixel(x, y);
              return [
                pixel.r / 255.0,
                pixel.g / 255.0,
                pixel.b / 255.0
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
        List.generate(224, (_) => List.generate(224, (_) => List.generate(3, (_) => 0.0)))
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
            if (_selectedImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  _selectedImage!,
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
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
