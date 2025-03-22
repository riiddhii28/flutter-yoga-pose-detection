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
}
