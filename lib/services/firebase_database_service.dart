import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// 📝 Save user details
  Future<void> saveUser(String uid, String email) async {
    await _db.collection("users").doc(uid).set({
      "email": email,
      "highestAccuracy": 0.0,  // Initial accuracy
      "createdAt": Timestamp.now(),
      "profileImageUrl": "",  
    });
  }

  /// 📜 Save pose detection history & update highest accuracy
  Future<void> savePoseHistory(String uid, String poseName, double accuracy, String imageUrl) async {
    await _db.collection("users").doc(uid).collection("pose_history").add({
      "poseName": poseName,
      "accuracy": accuracy,
      "imageUrl": imageUrl,
      "timestamp": Timestamp.now(),
    });

    // Update highest accuracy
    DocumentSnapshot userDoc = await _db.collection("users").doc(uid).get();
    double currentHighest = userDoc['highestAccuracy'] ?? 0.0;

    if (accuracy > currentHighest) {
      await _db.collection("users").doc(uid).update({"highestAccuracy": accuracy});
    }
  }

  /// 🔝 Fetch leaderboard (Top 10 users with highest accuracy)
  Stream<QuerySnapshot> getLeaderboard() {
    return _db.collection("users").orderBy("highestAccuracy", descending: true).limit(10).snapshots();
  }

  /// 📂 Fetch user pose history
  Stream<QuerySnapshot> getPoseHistory(String uid) {
    return _db.collection("users").doc(uid).collection("pose_history").orderBy("timestamp", descending: true).snapshots();
  }

  /// 🏆 Fetch user details
  Future<Map<String, dynamic>> getUserDetails(String uid) async {
    DocumentSnapshot doc = await _db.collection("users").doc(uid).get();
    return doc.exists ? doc.data() as Map<String, dynamic> : {};
  }

  /// 🖼 Update Profile Picture URL
  Future<void> updateProfilePicture(String uid, String imageUrl) async {
    await _db.collection("users").doc(uid).update({"profilePic": imageUrl});
  }

}
