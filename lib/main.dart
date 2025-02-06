import 'package:flutter/material.dart';
import 'pose_detector.dart';
import 'image_pose_detector.dart';

void main() {
  runApp(YogaBlissApp());
}

class YogaBlissApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'YogaBliss',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

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
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            
            // Button for Live Pose Detection
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => PoseDetectorScreen()));
              },
              child: Text('Start Live Pose Detection'),
            ),
            
            SizedBox(height: 20),
            
            // Button for Image Upload Pose Detection
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ImagePoseDetector()));
              },
              child: Text('Upload Image for Pose Detection'),
            ),
          ],
        ),
      ),
    );
  }
}
