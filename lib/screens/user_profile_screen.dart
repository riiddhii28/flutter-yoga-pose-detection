import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import '../services/firebase_database_service.dart';
import '../services/firebase_storage_service.dart';
import 'login_screen.dart';

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
  String profileImageUrl = "";

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    var user = _auth.currentUser;
    if (user != null) {
      var userData = await _dbService.getUserDetails(user.uid);
      setState(() {
        email = userData['email'];
        highestAccuracy = userData['highestAccuracy'];
        joinDate = userData['createdAt'].toDate().toString().split(' ')[0];
        profileImageUrl = userData['profileImageUrl'] ?? ""; // Get profile image
      });
    }
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      var user = _auth.currentUser;
      if (user != null) {
        String downloadUrl = await _storageService.uploadImage(imageFile, user.uid);
        await _dbService.updateUserProfileImage(user.uid, downloadUrl);
        setState(() {
          profileImageUrl = downloadUrl;
        });
      }
    }
  }

  void _logout() async {
    await _auth.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            profileImageUrl.isNotEmpty
                ? CircleAvatar(radius: 50, backgroundImage: NetworkImage(profileImageUrl))
                : Icon(Icons.account_circle, size: 100, color: Colors.blueAccent),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pickAndUploadImage,
              child: Text("Upload Profile Picture"),
            ),
            SizedBox(height: 20),
            Text("Email: $email", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("Highest Accuracy: ${(highestAccuracy * 100).toStringAsFixed(1)}%", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("Joined: $joinDate", style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _logout,
              icon: Icon(Icons.logout),
              label: Text("Logout"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
