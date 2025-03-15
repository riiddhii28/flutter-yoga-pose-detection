import 'dart:io';
import 'package:tflite_flutter/tflite_flutter.dart';

class YogaPoseClassifier {
  static late Interpreter _interpreter;
  static final List<String> _poses = ["Downdog", "Goddess", "Plank", "Tree", "Warrior2"];

  // Load model when class is first used
  static Future<void> loadModel() async {
    _interpreter = await Interpreter.fromAsset("assets/yoga_pose_classifier.tflite");
    print("✅ Model loaded successfully");
  }

  // Classify pose from image file
  static Future<String> classify(File imageFile) async {
    if (_interpreter == null) {
      await loadModel();
    }

    // Dummy input (Replace this with actual image processing logic)
    var input = List.filled(3, 0.0).reshape([1, 3]);
    var output = List.filled(5, 0.0).reshape([1, 5]);

    _interpreter.run(input, output);

    int maxIndex = output[0].indexWhere((element) => element == output[0].reduce((a, b) => a > b ? a : b));
    return "${_poses[maxIndex]} (Confidence: ${(output[0][maxIndex] * 100).toStringAsFixed(1)}%)";
  }

  static void close() {
    _interpreter.close();
  }
}
