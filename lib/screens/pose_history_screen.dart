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
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final poses = snapshot.data!.docs;
          return ListView.builder(
            itemCount: poses.length,
            itemBuilder: (context, index) {
              var poseData = poses[index];
              return ListTile(
                title: Text("Pose: ${poseData['poseName']}"),
                subtitle: Text("Accuracy: ${(poseData['accuracy'] * 100).toStringAsFixed(1)}%"),
                trailing: Text(poseData['timestamp'].toDate().toString().split('.')[0]),
              );
            },
          );
        },
      ),
    );
  }
}
