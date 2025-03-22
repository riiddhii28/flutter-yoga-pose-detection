import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/login_screen.dart';

class NavigationDrawer extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance; // ✅ Firebase instance

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Color(0xFFE9E8E7), // Light Beige Background
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _buildDrawerHeader(),
            _buildDrawerItem(context, Icons.home, "Home", "/home"),
            _buildDrawerItem(context, Icons.camera, "Pose Detection", "/poseDetection"),
            _buildDrawerItem(context, Icons.videocam, "Live Pose", "/livePose"),
            _buildDrawerItem(context, Icons.book, "Pose Guide", "/poseGuide"),
            _buildDrawerItem(context, Icons.leaderboard, "Leaderboard", "/leaderboard"),
            _buildDrawerItem(context, Icons.person, "My Profile", "/profile"),
            _buildDrawerItem(context, Icons.info_outline, "About", "/about"),
            Divider(color: Colors.black26), // ✅ Themed divider
            _buildDrawerItem(context, Icons.logout, "Logout", null, isLogout: true),
          ],
        ),
      ),
    );
  }

  /// 🎨 **Drawer Header with Themed Colors**
  Widget _buildDrawerHeader() {
    return DrawerHeader(
      decoration: BoxDecoration(
        color: Color(0xFFA89A8D), // Soft Taupe Header
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.spa, size: 50, color: Colors.white), // Yoga Icon
          SizedBox(height: 10),
          Text("YogaBliss", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
          Text("Your Personal Yoga Guide", style: TextStyle(color: Colors.white70, fontSize: 14)),
        ],
      ),
    );
  }

  /// 📌 **Drawer Item for Navigation**
  Widget _buildDrawerItem(BuildContext context, IconData icon, String title, String? route, {bool isLogout = false}) {
    return ListTile(
      leading: Icon(icon, color: isLogout ? Colors.red : Color(0xFF6D3A3F)), // Muted Wine Red Icons
      title: Text(title, style: TextStyle(fontSize: 16, color: Colors.black87)),
      onTap: () async {
        if (isLogout) {
          await _auth.signOut(); // ✅ Sign out user
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
        } else {
          Navigator.pop(context); // Close drawer
          if (route != null) Navigator.pushNamed(context, route);
        }
      },
    );
  }
}
