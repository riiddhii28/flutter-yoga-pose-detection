import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// 📤 Upload Image to Firebase Storage
  Future<String> uploadImage(File imageFile, String folderName) async {
    try {
      String fileName = basename(imageFile.path);
      Reference storageRef = _storage.ref().child("$folderName/$fileName");

      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;

      // ✅ Get Download URL
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error uploading image: $e");
      return "";
    }
  }


  // Method to upload video to Firebase Storage
  Future<String> uploadVideo(File videoFile, String folderName) async {
    try {
      String fileName = basename(videoFile.path); 
      Reference storageRef = _storage.ref().child("$folderName/$fileName"); 

      UploadTask uploadTask = storageRef.putFile(videoFile); // Start upload
      TaskSnapshot snapshot = await uploadTask; // Wait for upload to complete

      // Get download URL
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error uploading video: $e");
      return "";
    }
  }

}
