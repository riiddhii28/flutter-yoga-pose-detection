import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Uploads an image file to Firebase Storage
  Future<String> uploadImage(File imageFile, String userId) async {
    try {
      String fileName = basename(imageFile.path);
      Reference ref = _storage.ref("user_poses/$userId/$fileName");
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL(); // Return the image URL
    } catch (e) {
      throw Exception("Failed to upload image: $e");
    }
  }
}
