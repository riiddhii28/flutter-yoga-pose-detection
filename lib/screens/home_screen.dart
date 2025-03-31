import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F5F0),
      appBar: AppBar(
        title: Text("YogaBliss 🧘‍♂️", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF6D3A3F), 
        elevation: 0,
      ),
      drawer: _buildDrawer(context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Hero Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    "assets/images/yoga_home.png",
                    height: 170,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 20),

                // Welcome Text
                Text(
                  "Welcome to YogaBliss!",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF6D3A3F)),
                ),
                SizedBox(height: 8),
                Text(
                  "Enhance your yoga practice with AI-powered pose detection and guidance.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                SizedBox(height: 20),

                // Feature Buttons
                _buildFeatureButton(
                  context,
                  "📸 Image Pose Detection",
                  "Detect your yoga pose in real-time or from an image.",
                  Icons.camera_alt_rounded,
                  "/poseDetection",
                ),
                _buildFeatureButton(
                  context,
                  "📹 Live Pose Detection",
                  "Use your camera to detect yoga poses in real-time.",
                  Icons.videocam_rounded,
                  "/livePose",
                ),
                _buildFeatureButton(
                  context,
                  "📖 Pose Guide",
                  "Learn the correct form of different yoga poses.",
                  Icons.book_rounded,
                  "/poseGuide",
                ),
                _buildFeatureButton(
                  context,
                  "🏆 Leaderboard",
                  "Track progress and compare with others.",
                  Icons.leaderboard_rounded,
                  "/leaderboard",
                ),
                _buildFeatureButton(
                  context,
                  "🧘‍♂️ Yoga Courses",
                  "Explore yoga courses and videos.",
                  Icons.video_library_rounded,
                  "/yogaCourses", 
                ),
                _buildFeatureButton(
                  context,
                  "👤 My Profile",
                  "View and update your profile.",
                  Icons.person_rounded,
                  "/profile",
                ),
                _buildFeatureButton(
                  context,
                  "ℹ️ About",
                  "Learn more about YogaBliss and its features.",
                  Icons.info_outline_rounded,
                  "/about",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 📜 Sidebar Drawer (Improved UI & Added Pose History)
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Drawer Header
          DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF6D3A3F)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.spa_rounded, size: 50, color: Colors.white),
                SizedBox(height: 10),
                Text("YogaBliss", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                Text("Your Personal Yoga Guide", style: TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),

          // Navigation Items
          _buildDrawerItem(context, Icons.camera_alt_rounded, "Pose Detection", "/poseDetection"),
          _buildDrawerItem(context, Icons.book_rounded, "Pose Guide", "/poseGuide"),
          _buildDrawerItem(context, Icons.leaderboard_rounded, "Leaderboard", "/leaderboard"),
          _buildDrawerItem(context, Icons.video_library_rounded, "Yoga Courses", "/yogaCourses"),
          _buildDrawerItem(context, Icons.person_rounded, "My Profile", "/profile"),
          _buildDrawerItem(context, Icons.info_outline_rounded, "About", "/about"),

          Divider(), // ✅ Separate logout option

          _buildDrawerItem(context, Icons.logout_rounded, "Logout", null, isLogout: true),
        ],
      ),
    );
  }

  /// 📌 Feature Button (For Home Page)
  Widget _buildFeatureButton(BuildContext context, String title, String subtitle, IconData icon, String route) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      color: Colors.white,
      child: ListTile(
        leading: Icon(icon, color: Color(0xFF6D3A3F), size: 28),
        title: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.black54)),
        trailing: Icon(Icons.arrow_forward_ios_rounded, size: 18, color: Colors.black54),
        onTap: () {
          Navigator.pushNamed(context, route);
        },
      ),
    );
  }

  /// 📌 Drawer Item (For Sidebar Navigation)
  Widget _buildDrawerItem(BuildContext context, IconData icon, String title, String? route, {bool isLogout = false}) {
    return ListTile(
      leading: Icon(icon, color: isLogout ? Colors.red : Color(0xFF6D3A3F)),
      title: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      onTap: () async {
        if (isLogout) {
          await _auth.signOut();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
        } else {
          Navigator.pop(context);
          if (route != null) Navigator.pushNamed(context, route);
        }
      },
    );
  }
}
