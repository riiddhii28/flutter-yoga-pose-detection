import 'package:flutter/material.dart';

class ResultDisplay extends StatelessWidget {
  final String poseName;
  final double confidence;

  const ResultDisplay({
    Key? key,
    required this.poseName,
    required this.confidence,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Detected Pose:",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 10),
        Text(
          poseName.isNotEmpty ? "$poseName (Confidence: ${(confidence * 100).toStringAsFixed(1)}%)" : "Unknown Pose",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: poseName.isNotEmpty ? Colors.blueAccent : Colors.redAccent,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
