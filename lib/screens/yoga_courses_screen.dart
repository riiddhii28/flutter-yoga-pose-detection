import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'yoga_video_player_screen.dart';


// Yoga Course Model
class YogaCourse {
  final String courseName;
  final String description;
  final String videoPath;  // Changed to use local video path
  final String thumbnailUrl;

  YogaCourse({
    required this.courseName,
    required this.description,
    required this.videoPath, // Changed to use local video path
    required this.thumbnailUrl,
  });

  // Convert Firestore data into a YogaCourse object (if you're still using it)
  // Otherwise, you can use the model directly with local data
  factory YogaCourse.fromFirestore(Map<String, dynamic> data) {
    return YogaCourse(
      courseName: data['courseName'],
      description: data['description'],
      videoPath: data['videoPath'], // Changed to use local video path
      thumbnailUrl: data['thumbnailUrl'],
    );
  }
}

class YogaCoursesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Yoga Courses", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF6D3A3F), // Wine red
        elevation: 0,
      ),
      body: ListView(
        children: [
          // Example yoga course card
          Card(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(15),
              leading: Image.asset('assets/images/yoga_thumbnail.png', width: 60, height: 60, fit: BoxFit.cover), // Example thumbnail
              title: Text("Beginner Yoga", style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("A basic yoga course for beginners"),
              onTap: () {
                // Open video player screen with local video asset path
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => YogaVideoPlayerScreen('assets/yoga_video.mp4'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
