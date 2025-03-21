import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firebase_database_service.dart';

class LeaderboardScreen extends StatelessWidget {
  final FirebaseDatabaseService _dbService = FirebaseDatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Leaderboard")),
      body: StreamBuilder<QuerySnapshot>(
        stream: _dbService.getLeaderboard(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final users = snapshot.data!.docs;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var user = users[index];
              return ListTile(
                leading: Text("#${index + 1}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                title: Text(user['email']),
                subtitle: Text("Highest Accuracy: ${(user['highestAccuracy'] * 100).toStringAsFixed(1)}%"),
                trailing: Icon(Icons.emoji_events, color: Colors.amber),
              );
            },
          );
        },
      ),
    );
  }
}
