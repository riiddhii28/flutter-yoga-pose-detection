import 'dart:io';
import 'package:tflite_flutter/tflite_flutter.dart';

class YogaPoseClassifier {
  static Interpreter? _interpreter;
  static final List<String> _poses = ["Downdog", "Goddess", "Plank", "Tree", "Warrior2", "UnknownPose"];

  // Load model when class is first used
  static Future<void> loadModel() async {
    if (_interpreter == null) {
      _interpreter = await Interpreter.fromAsset("assets/yoga_pose_classifier.tflite");
      print("✅ Model loaded successfully");
    }
  }

  // Classify pose from image file
  static Future<String> classify(File imageFile) async {
    if (_interpreter == null) await loadModel();

    // Placeholder for image preprocessing (Convert image to model input)
    var input = List.filled(1 * 224 * 224 * 3, 0.0).reshape([1, 224, 224, 3]); 
    var output = List.filled(6, 0.0).reshape([1, 6]);

    _interpreter!.run(input, output);

    int maxIndex = 0;
    double maxConfidence = 0.0;

    for (int i = 1; i < output[0].length; i++) {
      if (output[0][i] > maxConfidence) {
        maxConfidence = output[0][i];
        maxIndex = i - 1;
      }
    }

    String detectedPose = (maxConfidence < 0.1) ? "No pose detected" : _poses[maxIndex];

    return "$detectedPose (Accuracy: ${(maxConfidence * 100).toStringAsFixed(1)}%)";
  }

  // Dispose interpreter
  static void close() {
    _interpreter?.close();
    _interpreter = null;
  }
}
