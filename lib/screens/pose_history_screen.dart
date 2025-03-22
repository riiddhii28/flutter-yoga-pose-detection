import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_database_service.dart';

class PoseHistoryScreen extends StatefulWidget {
  @override
  _PoseHistoryScreenState createState() => _PoseHistoryScreenState();
}

class _PoseHistoryScreenState extends State<PoseHistoryScreen> {
  final FirebaseDatabaseService _dbService = FirebaseDatabaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F5F0), // Light beige background
      appBar: AppBar(
        title: Text("Pose History", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF6D3A3F), // Wine Red Header
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _dbService.getPoseHistory(_auth.currentUser!.uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final poses = snapshot.data!.docs;
          if (poses.isEmpty) {
            return Center(
              child: Text(
                "No pose history found.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            itemCount: poses.length,
            itemBuilder: (context, index) {
              var poseData = poses[index];
              String poseName = poseData['poseName'];
              double accuracy = poseData['accuracy'] * 100;
              String timestamp = poseData['timestamp'].toDate().toString().split('.')[0];
              String? imageUrl = poseData['imageUrl']; // ✅ Get pose image URL

              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 3,
                margin: EdgeInsets.symmetric(vertical: 10),
                color: Colors.white,
                child: ListTile(
                  contentPadding: EdgeInsets.all(12),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: imageUrl != null && imageUrl.isNotEmpty
                        ? Image.network(imageUrl, width: 60, height: 60, fit: BoxFit.cover)
                        : Icon(Icons.image_not_supported, size: 60, color: Colors.grey),
                  ),
                  title: Text("Pose: $poseName", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6D3A3F))),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4),
                      Text("Accuracy: ${accuracy.toStringAsFixed(1)}%", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87)),
                      SizedBox(height: 4),
                      Text("Time: $timestamp", style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
