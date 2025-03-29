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
                  color: Color(0xFF1D1B1A), // Dark Charcoal
                ),
              ),
              SizedBox(height: 8),

              Text(
                poseName, // Always show the pose name
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: poseName == "No pose detected"
                      ? Colors.redAccent // Highlight for no detection
                      : Color(0xFF6D3A3F), // Wine Red for valid poses
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 8),

              // ✅ Show accuracy only for valid poses
              if (poseName != "No pose detected" && poseName != "UnknownPose")
                Column(
                  children: [
                    Text(
                      "Accuracy: ${(accuracy * 100).toStringAsFixed(1)}%", // Display accuracy
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFA89A8D), // Taupe
                      ),
                    ),
                    SizedBox(height: 16),
                    // Animated accuracy bar
                    AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      width: accuracy * 200, // Width based on accuracy
                      height: 10,
                      decoration: BoxDecoration(
                        color: Color(0xFF6D3A3F), // Wine Red
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
