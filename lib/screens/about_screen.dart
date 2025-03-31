import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F5F0), 
      appBar: AppBar(
        title: Text("About YogaBliss", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF6D3A3F), 
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // App Logo
              ClipRRect(
                borderRadius: BorderRadius.circular(15), 
                child: Image.asset(
                  "assets/images/yoga_logo.png",
                  height: 120,
                ),
              ),
              SizedBox(height: 20),

              // App Title
              Text(
                "Welcome to YogaBliss 🧘‍♀️",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6D3A3F),
                ),
              ),
              SizedBox(height: 10),

              // App Description
              Text(
                "Your personal AI-powered yoga assistant! Improve your yoga practice with real-time pose detection and guided exercises, whether you're a beginner or an expert.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              SizedBox(height: 20),

              // Features Section
              _buildSectionTitle("✨ Features"),
              _buildFeatureItem("📷 Pose Detection", "Upload an image or use the camera to detect yoga poses."),
              _buildFeatureItem("📖 Pose Guide", "Learn correct postures with step-by-step instructions."),
              _buildFeatureItem("📈 Progress Tracker", "Monitor your improvement over time."),
              _buildFeatureItem("🧘 Yoga Resources", "Discover benefits, breathing exercises, and more."),
              _buildFeatureItem("🔔 Reminders & Challenges", "Set daily goals and stay motivated."),
              _buildFeatureItem("📜 Pose History", "Track your past yoga poses and improvements."), 

              SizedBox(height: 30),

              // Team Credit
              Center(
                child: Text(
                  "Made with ❤️ by the YogaBliss Team",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 📌 Section Title Widget
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF6D3A3F)),
      ),
    );
  }

  /// 📌 Feature Item Widget
  Widget _buildFeatureItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, color: Color(0xFF6D3A3F)), 
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                Text(
                  description,
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
