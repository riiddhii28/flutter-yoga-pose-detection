import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firebase_database_service.dart';

class LeaderboardScreen extends StatelessWidget {
  final FirebaseDatabaseService _dbService = FirebaseDatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F5F0), // Light beige background
      appBar: AppBar(
        title: Text("🏆 Leaderboard", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF6D3A3F), // Wine red
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _dbService.getLeaderboard(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final users = snapshot.data!.docs;
          if (users.isEmpty) {
            return Center(
              child: Text(
                "No leaderboard data available.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                var user = users[index];
                String rankBadge = _getRankBadge(index);
                Color cardColor = _getCardColor(index);
                double accuracy = (user['highestAccuracy'] * 100);

                return Card(
                  color: cardColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Text(
                        "${index + 1}",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                    ),
                    title: Text(
                      user['email'],
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Highest Accuracy: ${accuracy.toStringAsFixed(1)}%",
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    trailing: Text(
                      rankBadge,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  /// 🏅 Returns Rank Badge
  String _getRankBadge(int index) {
    if (index == 0) return "🥇"; // Gold
    if (index == 1) return "🥈"; // Silver
    if (index == 2) return "🥉"; // Bronze
    return "⭐"; // Normal star for others
  }

  /// 🎨 Returns Card Background Color Based on Rank
  Color _getCardColor(int index) {
    if (index == 0) return Colors.amber.shade200; // Gold
    if (index == 1) return Colors.grey.shade300;  // Silver
    if (index == 2) return Colors.brown.shade300; // Bronze
    return Colors.white;
  }
}
