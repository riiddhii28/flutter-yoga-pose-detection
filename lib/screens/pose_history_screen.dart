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
      appBar: AppBar(title: Text("Pose History")),
      body: StreamBuilder<QuerySnapshot>(
        stream: _dbService.getPoseHistory(_auth.currentUser!.uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final poses = snapshot.data!.docs;
          if (poses.isEmpty) {
            return Center(
              child: Text("No pose history found.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }

          return ListView.builder(
            itemCount: poses.length,
            itemBuilder: (context, index) {
              var poseData = poses[index];
              String poseName = poseData['poseName'];
              double accuracy = poseData['accuracy'] * 100;
              String timestamp = poseData['timestamp'].toDate().toString().split('.')[0];
              String? imageUrl = poseData['imageUrl']; // ✅ Get pose image URL

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ListTile(
                  leading: imageUrl != null && imageUrl.isNotEmpty
                      ? Image.network(imageUrl, width: 50, height: 50, fit: BoxFit.cover)
                      : Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                  title: Text("Pose: $poseName", style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Accuracy: ${accuracy.toStringAsFixed(1)}%"),
                      Text("Time: $timestamp", style: TextStyle(color: Colors.grey)),
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
