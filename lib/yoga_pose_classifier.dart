import 'dart:typed_data';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class YogaPoseClassifier {
  late Interpreter _interpreter;
  final int inputSize = 224; // Ensure this matches your TFLite model
  final List<String> labels = ["Downdog", "Goddess", "Plank", "Tree", "Warrior2"];

  YogaPoseClassifier() {
    _loadModel();
  }

  Future<void> _loadModel() async {
    _interpreter = await Interpreter.fromAsset('assets/yoga_pose_classifier.tflite');
  }

String classifyPose(img.Image image) {
  var input = _preprocessImage(image);

  if (_interpreter == null) {
    return "Error: Model not loaded!";
  }

  // Output buffer
  var output = List.filled(labels.length, 0.0).reshape([1, labels.length]);

  try {
    _interpreter.run(input, output);

    if (output.isEmpty || output[0].isEmpty) {
      return "Unknown Pose";
    }

    // Convert output to List<double>
    List<double> outputList = List<double>.from(output[0]);

    // Print raw output for debugging
    print("Model Output: $outputList");

    // Find highest confidence score
    double maxConfidence = outputList.reduce((a, b) => a > b ? a : b);
    int maxIndex = outputList.indexOf(maxConfidence);

    // Print confidence scores
    for (int i = 0; i < labels.length; i++) {
      print("${labels[i]}: ${outputList[i].toStringAsFixed(3)}");
    }

    // Confidence threshold
    if (maxConfidence < 0.5) {
      return "Unknown Pose";
    }

    return labels[maxIndex];
  } catch (e) {
    return "Error: ${e.toString()}";
  }
}


List<List<List<List<double>>>> _preprocessImage(img.Image image) {
  // Resize to model's input size (adjust if needed)
  img.Image resized = img.copyResize(image, width: 224, height: 224);

  // Normalize to [0, 1] range
  List<List<List<List<double>>>> input = List.generate(
    1,
    (i) => List.generate(
      224,
      (y) => List.generate(
        224,
        (x) {
          img.Pixel pixel = resized.getPixel(x, y);
          return [
            pixel.r / 255.0,
            pixel.g / 255.0,
            pixel.b / 255.0,
          ];
        },
      ),
    ),
  );

  return input;
}

}
