import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("About YogaBliss")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                "assets/images/yoga_logo.png", // Add your app logo here
                height: 100,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Welcome to YogaBliss 🧘‍♀️",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "YogaBliss is your personal yoga assistant, designed to help you improve your yoga practice with AI-powered pose detection. Whether you're a beginner or an expert, our app provides real-time feedback and guidance.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              "✨ Features:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildFeatureItem("📷 Pose Detection", "Upload an image or use the camera to detect yoga poses."),
            _buildFeatureItem("📖 Pose Guide", "Learn correct postures with step-by-step instructions."),
            _buildFeatureItem("📈 Progress Tracker", "Monitor your improvement over time."),
            _buildFeatureItem("🧘 Yoga Resources", "Discover benefits, breathing exercises, and more."),
            _buildFeatureItem("🔔 Reminders & Challenges", "Set daily goals and stay motivated."),
            Spacer(),
            Center(
              child: Text(
                "Made with ❤️ by YogaBliss Team",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, color: Colors.green),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  description,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
