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
    bool isUnknownOrNoPose = poseName == "No pose detected" || poseName == "UnknownPose";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Color(0xFFE9E8E7), // Light Beige Background
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Detected Pose:",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1D1B1A),
                ),
              ),
              SizedBox(height: 8),

              Text(
                poseName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: isUnknownOrNoPose
                      ? Colors.redAccent
                      : Color(0xFF6D3A3F), // Wine Red for valid poses
                ),
                textAlign: TextAlign.center,
              ),

              if (!isUnknownOrNoPose) ...[
                SizedBox(height: 8),
                Text(
                  "Accuracy: ${(accuracy * 100).toStringAsFixed(1)}%",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFA89A8D), // Taupe
                  ),
                ),
                SizedBox(height: 16),
                AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  width: (accuracy * 200).clamp(10.0, 200.0), // Min width 10px
                  height: 10,
                  decoration: BoxDecoration(
                    color: Color(0xFF6D3A3F), // Wine Red
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
