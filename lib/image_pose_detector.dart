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
  double _confidence = 0.0;
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
      _detectedPose = "Processing...";
      _confidence = 0.0;
    });

    await _detectPose();
  }

Future<void> _detectPose() async {
  if (_selectedImage == null || _interpreter == null) {
    setState(() {
      _detectedPose = "Error in detection";
    });
    return;
  }

  try {
    // Load and preprocess the image
    List<List<List<List<double>>>> input = await _preprocessImage(_selectedImage!);

    // Prepare output buffer (change 5 → 6)
    var output = List.filled(6, 0.0).reshape([1, 6]);

    print("✅ Running inference...");
    _interpreter!.run(input, output);

    // Get highest confidence index
    int maxIndex = 0;
    double maxConfidence = 0.0;
    for (int i = 1; i < output[0].length; i++) {
      if (output[0][i] > maxConfidence) {
        maxConfidence = output[0][i];
        maxIndex = i - 1;
      }
    }

    List<String> poseLabels = ["Downdog", "Goddess", "Plank", "Tree", "Warrior2", "UnknownPose"];

    setState(() {
      _detectedPose = poseLabels[maxIndex];
      _confidence = maxConfidence;
    });

    print("🧘 Pose Detected: $_detectedPose (Confidence: ${(_confidence * 100).toStringAsFixed(1)}%)");
  } catch (e) {
    setState(() {
      _detectedPose = "Error in detection";
    });
    print("❌ Error detecting pose: $e");
  }
}


  /// 📏 Preprocess Image (Fixed Issues)
  Future<List<List<List<List<double>>>>> _preprocessImage(File imageFile) async {
    try {
      Uint8List imageBytes = await imageFile.readAsBytes();
      img.Image? image = img.decodeImage(imageBytes);
      if (image == null) {
        throw Exception("Failed to decode image");
      }

      // ✅ Resize image to 224x224
      img.Image resizedImage = img.copyResize(image, width: 224, height: 224);

      // ✅ Convert to normalized tensor format (4D: [1, 224, 224, 3])
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
                pixel.b / 255.0 // Normalize Blue
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
      appBar: AppBar(title: Text("Upload Image for Detection")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _selectedImage == null
              ? Text("No image selected", style: TextStyle(fontSize: 18))
              : Image.file(_selectedImage!, height: 250),

          SizedBox(height: 20),

          ElevatedButton(
            onPressed: _pickImage,
            child: Text("Pick Image"),
          ),

          SizedBox(height: 20),

          // ✅ Display Pose Detection Result
          ResultDisplay(poseName: _detectedPose, confidence: _confidence),
        ],
      ),
    );
  }
}
