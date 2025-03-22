import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance; // ✅ Firebase Auth instance

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("YogaBliss 🧘‍♂️")),
      drawer: _buildDrawer(context), // ✅ Updated drawer with logout
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Image.asset(
                  "assets/images/yoga_home.png",
                  height: 150,
                  fit: BoxFit.cover, // Prevent overflow
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

                // Feature Buttons
                _buildFeatureButton(
                  context,
                  "📸 Image Pose Detection",
                  "Detect your yoga pose in real-time or from an image.",
                  Icons.camera,
                  "/poseDetection",
                ),
                _buildFeatureButton(
                  context,
                  "📹 Live Pose Detection",
                  "Use your camera to detect yoga poses in real-time.",
                  Icons.videocam,
                  "/livePose",
                ),
                _buildFeatureButton(
                  context,
                  "📖 Pose Guide",
                  "Learn the correct form of different yoga poses.",
                  Icons.book,
                  "/poseGuide",
                ),
                _buildFeatureButton(
                  context,
                  "🏆 Leaderboard",
                  "Track progress and compare with others.",
                  Icons.leaderboard,
                  "/leaderboard",
                ),
                _buildFeatureButton(
                  context,
                  "👤 My Profile",
                  "View and update your profile.",
                  Icons.person,
                  "/profile",
                ),
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
      ),
    );
  }

  /// 📜 Drawer for Navigation (Updated with Logout)
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
          _buildDrawerItem(context, Icons.leaderboard, "Leaderboard", "/leaderboard"),
          _buildDrawerItem(context, Icons.person, "My Profile", "/profile"),
          _buildDrawerItem(context, Icons.info_outline, "About", "/about"),
          Divider(), // ✅ Separate logout option
          _buildDrawerItem(context, Icons.logout, "Logout", null, isLogout: true),
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
  Widget _buildDrawerItem(BuildContext context, IconData icon, String title, String? route, {bool isLogout = false}) {
    return ListTile(
      leading: Icon(icon, color: isLogout ? Colors.red : Colors.blueAccent),
      title: Text(title, style: TextStyle(fontSize: 16)),
      onTap: () async {
        if (isLogout) {
          await _auth.signOut(); // ✅ Sign out
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
        } else {
          Navigator.pop(context);
          if (route != null) Navigator.pushNamed(context, route);
        }
      },
    );
  }
}
