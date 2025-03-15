import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("YogaBliss 🧘‍♂️")),
      drawer: _buildDrawer(context), // Side navigation drawer
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/yoga_home.png", // Add a yoga-themed image
                height: 150,
              ),
              SizedBox(height: 20),
              Text(
                "Welcome to YogaBliss!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Improve your yoga practice with AI-powered pose detection and guided exercises.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              SizedBox(height: 20),

              // 📸 Pose Detection Button
              _buildFeatureButton(
                context,
                "📸 Image Pose Detection",
                "Detect your yoga pose in real-time or from an image.",
                Icons.camera,
                "/poseDetection",
              ),

              // 📹 Live Pose Detection Button
              _buildFeatureButton(
                context,
                "📹 Live Pose Detection",
                "Use your camera to detect yoga poses in real-time.",
                Icons.videocam,
                "/livePose",
              ),

              // 📖 Pose Guide Button
              _buildFeatureButton(
                context,
                "📖 Pose Guide",
                "Learn the correct form of different yoga poses.",
                Icons.book,
                "/poseGuide",
              ),

              // ℹ️ About Page Button
              _buildFeatureButton(
                context,
                "ℹ️ About",
                "Learn more about YogaBliss and its features.",
                Icons.info_outline,
                "/about",
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 📜 Drawer for Navigation
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blueAccent),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.spa, size: 50, color: Colors.white),
                SizedBox(height: 10),
                Text("YogaBliss", style: TextStyle(color: Colors.white, fontSize: 22)),
                Text("Your Personal Yoga Guide", style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          _buildDrawerItem(context, Icons.camera, "Pose Detection", "/poseDetection"),
          _buildDrawerItem(context, Icons.book, "Pose Guide", "/poseGuide"),
          _buildDrawerItem(context, Icons.info_outline, "About", "/about"),
        ],
      ),
    );
  }

  /// 📌 Feature Button (For Home Page)
  Widget _buildFeatureButton(BuildContext context, String title, String subtitle, IconData icon, String route) {
    return Card(
      elevation: 3,
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent),
        title: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.black54)),
        trailing: Icon(Icons.arrow_forward_ios, size: 18, color: Colors.black54),
        onTap: () {
          Navigator.pushNamed(context, route);
        },
      ),
    );
  }

  /// 📌 Drawer Item (For Sidebar Navigation)
  Widget _buildDrawerItem(BuildContext context, IconData icon, String title, String route) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(title, style: TextStyle(fontSize: 16)),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, route);
      },
    );
  }
}
