import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_storage_service.dart';
import '../services/firebase_database_service.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabaseService _dbService = FirebaseDatabaseService();
  final FirebaseStorageService _storageService = FirebaseStorageService();
  String email = "";
  double highestAccuracy = 0.0;
  String joinDate = "";
  String profilePicUrl = "";

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  /// 📤 Fetch User Details
  Future<void> _fetchUserProfile() async {
    var user = _auth.currentUser;
    if (user != null) {
      var userData = await _dbService.getUserDetails(user.uid);
      setState(() {
        email = userData['email'];
        highestAccuracy = userData['highestAccuracy'];
        joinDate = userData['createdAt'].toDate().toString().split(' ')[0];
        profilePicUrl = userData['profilePic'] ?? "";
      });
    }
  }

  /// 📸 Pick & Upload Profile Picture
  Future<void> _uploadProfilePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      String downloadUrl = await _storageService.uploadImage(imageFile, "profile_pictures");

      if (downloadUrl.isNotEmpty) {
        var user = _auth.currentUser;
        await _dbService.updateProfilePicture(user!.uid, downloadUrl);
        setState(() => profilePicUrl = downloadUrl);
      }
    }
  }

  /// 🚪 Logout User
  void _logout() async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, "/login");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F5F0), // Light beige background
      appBar: AppBar(
        title: Text("My Profile", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF6D3A3F), // Wine Red Header
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Picture
            GestureDetector(
              onTap: _uploadProfilePicture,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey.shade300,
                backgroundImage: profilePicUrl.isNotEmpty
                    ? NetworkImage(profilePicUrl)
                    : AssetImage("assets/images/default_avatar.png") as ImageProvider,
                child: profilePicUrl.isEmpty
                    ? Icon(Icons.camera_alt, color: Colors.grey.shade600, size: 30)
                    : null,
              ),
            ),
            SizedBox(height: 20),

            // User Details
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 4,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: Column(
                  children: [
                    _buildProfileRow(Icons.email, "Email", email),
                    Divider(color: Colors.grey.shade300),
                    _buildProfileRow(Icons.stars, "Highest Accuracy", "${(highestAccuracy * 100).toStringAsFixed(1)}%"),
                    Divider(color: Colors.grey.shade300),
                    _buildProfileRow(Icons.calendar_today, "Joined", joinDate),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),

            // Logout Button with Gradient
            ElevatedButton(
              onPressed: _logout,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF6D3A3F), Color(0xFFA89A8D)], // Wine Red → Taupe Gradient
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(vertical: 14),
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.logout, color: Colors.white),
                    SizedBox(width: 10),
                    Text("Logout", style: TextStyle(fontSize: 18, color: Colors.white)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🏷️ Helper Function to Build Profile Rows
  Widget _buildProfileRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFF6D3A3F)), // Wine Red Icons
          SizedBox(width: 10),
          Text(label, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          Spacer(),
          Text(value, style: TextStyle(fontSize: 18, color: Colors.grey.shade700)),
        ],
      ),
    );
  }
}
