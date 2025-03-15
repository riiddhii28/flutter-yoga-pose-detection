import 'package:flutter/material.dart';
import 'live_pose_detector.dart';
import 'image_pose_detector.dart';
import 'widgets/custom_button.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('YogaBliss'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to YogaBliss',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // Live Pose Detection
            CustomButton(
              text: 'Start Live Pose Detection',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LivePoseDetector()),
                );
              },
            ),

            SizedBox(height: 20),

            // Image Upload Pose Detection
            CustomButton(
              text: 'Upload Image for Pose Detection',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ImagePoseDetector()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
