import 'package:flutter/material.dart';

class ResultDisplay extends StatelessWidget {
  final String poseName;
  final double accuracy;

  const ResultDisplay({
    Key? key,
    required this.poseName,
    required this.accuracy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // If no pose is detected, show nothing
    if (poseName.isEmpty) {
      return SizedBox(); // Empty widget
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Detected Pose:",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 10),
        Text(
          poseName,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.blueAccent,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Text(
          "Accuracy: ${(accuracy * 100).toStringAsFixed(1)}%", // Display accuracy
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.green,
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
