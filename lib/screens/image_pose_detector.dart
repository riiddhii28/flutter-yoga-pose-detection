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
  String _detectedPose = "No pose detected";
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

  /// 📸 Pick Image from Gallery
  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    setState(() {
      _selectedImage = File(pickedFile.path);
      _detectedPose = "Detecting...";
      _accuracy = 0.0;
    });

    await _detectPose();
  }

  /// 🔍 Detect Pose (With "No Pose Detected" Handling)
  Future<void> _detectPose() async {
    if (_selectedImage == null || _interpreter == null) {
      setState(() {
        _detectedPose = "Error in detection";
        _accuracy = 0.0;
      });
      return;
    }

    try {
      print("📸 Image Selected: ${_selectedImage!.path}");

      List<List<List<List<double>>>> input = await _preprocessImage(_selectedImage!);
      var output = List.filled(6, 0.0).reshape([1, 6]);

      print("✅ Running inference...");
      _interpreter!.run(input, output);
      print("📊 Model Output: $output");

      int maxIndex = 0;
      double maxAccuracy = 0.0;

      for (int i = 1; i < output[0].length; i++) {  
        if (output[0][i] > maxAccuracy) {
          maxAccuracy = output[0][i];
          maxIndex = i - 1;
        }
      }

      // ✅ Labels must match the output shape [1, 6]
      List<String> poseLabels = ["Downdog", "Goddess", "Plank", "Tree", "Warrior2", "UnknownPose"];

      // ✅ Apply Confidence Filtering
      String detectedPose;
      if (maxAccuracy < 0.1) {  
        detectedPose = "No Pose Detected"; // No valid pose
      } else if (maxAccuracy < 0.6) {  
        detectedPose = "Unknown Pose"; // Likely not a yoga pose
      } else {
        detectedPose = poseLabels[maxIndex]; // Confident match
      }

      setState(() {
        _detectedPose = detectedPose;
        _accuracy = maxAccuracy;
      });

      print("🧘 Pose Detected: $_detectedPose (Accuracy: ${(_accuracy * 100).toStringAsFixed(1)}%)");
    } catch (e) {
      setState(() {
        _detectedPose = "Error in detection";
        _accuracy = 0.0;
      });
      print("❌ Error detecting pose: $e");
    }
  }

  /// 📏 Preprocess Image (Fix `getPixel` Error)
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
              var pixel = resizedImage.getPixelSafe(x, y); // ✅ FIXED getPixel()
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
      backgroundColor: Color(0xFFF8F5F2),
      appBar: AppBar(
        title: Text("🧘 Yoga Pose Detector", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF6D3A3F),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_selectedImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  _selectedImage!,
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
            else
              Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text("No image selected", style: TextStyle(fontSize: 18, color: Colors.black54)),
                ),
              ),

            SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: Icon(Icons.photo_library),
              label: Text("Pick Image"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6D3A3F),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
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
