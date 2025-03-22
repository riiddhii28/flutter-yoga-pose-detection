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
      appBar: AppBar(title: Text("My Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _uploadProfilePicture,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: profilePicUrl.isNotEmpty
                    ? NetworkImage(profilePicUrl)
                    : AssetImage("assets/images/default_avatar.png") as ImageProvider,
              ),
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
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
