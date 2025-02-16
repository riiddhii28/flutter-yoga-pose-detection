import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class ImagePoseDetector extends StatefulWidget {
  @override
  _ImagePoseDetectorState createState() => _ImagePoseDetectorState();
}

class _ImagePoseDetectorState extends State<ImagePoseDetector> {
  File? _selectedImage;
  String _poseInfo = "No pose detected";
  final ImagePicker _picker = ImagePicker();
  final PoseDetector _poseDetector = PoseDetector(options: PoseDetectorOptions());

  /// Pick an image either from the gallery or by capturing a new one.
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        print("Picked image path: ${image.path}");
        setState(() {
          _selectedImage = File(image.path);
          _poseInfo = "Processing...";
        });
        _detectPose(File(image.path));
      } else {
        print("Image capture was cancelled or no image selected.");
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  /// Run pose detection on the selected image.
  Future<void> _detectPose(File imageFile) async {
    try {
      final inputImage = InputImage.fromFile(imageFile);
      final poses = await _poseDetector.processImage(inputImage);
      
      String detectedPose = "No yoga pose recognized";
      if (poses.isNotEmpty) {
        // Use the first detected pose for recognition.
        detectedPose = recognizeYogaPose(poses.first);
      }
      
      setState(() {
        _poseInfo = detectedPose;
      });
    } catch (e) {
      print("Error detecting pose: $e");
      setState(() {
        _poseInfo = "Error detecting pose";
      });
    }
  }

  /// A heuristic function to recognize Tadasana (Mountain Pose).
  /// It checks if the shoulders are nearly horizontal and that there is sufficient
  /// vertical separation between shoulders and hips.
  String recognizeYogaPose(Pose pose) {
    final leftShoulder = pose.landmarks[PoseLandmarkType.leftShoulder];
    final rightShoulder = pose.landmarks[PoseLandmarkType.rightShoulder];
    final leftHip = pose.landmarks[PoseLandmarkType.leftHip];
    final rightHip = pose.landmarks[PoseLandmarkType.rightHip];

    if (leftShoulder == null ||
        rightShoulder == null ||
        leftHip == null ||
        rightHip == null) {
      return "Insufficient data to recognize pose";
    }

    // Calculate differences (in pixel values) between landmarks.
    double shoulderDiff = (leftShoulder.y - rightShoulder.y).abs();
    double hipDiff = (leftHip.y - rightHip.y).abs();
    double shoulderToHipDiffLeft = (leftShoulder.y - leftHip.y).abs();
    double shoulderToHipDiffRight = (rightShoulder.y - rightHip.y).abs();

    // Debug logs: Print the differences to adjust thresholds as needed.
    print("Shoulder Diff: $shoulderDiff, Hip Diff: $hipDiff, "
          "Left Shoulder-Hip Diff: $shoulderToHipDiffLeft, Right Shoulder-Hip Diff: $shoulderToHipDiffRight");

    // Relaxed thresholds: Adjust these values based on your testing and image resolution.
    if (shoulderDiff < 40 &&
        hipDiff < 40 &&
        shoulderToHipDiffLeft > 50 &&
        shoulderToHipDiffRight > 50) {
      return "Tadasana (Mountain Pose)";
    }

    return "Unknown Pose";
  }

  @override
  void dispose() {
    _poseDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Yoga Pose Detection')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            _selectedImage != null
                ? Image.file(_selectedImage!, height: 300, fit: BoxFit.cover)
                : Container(
                    height: 300,
                    color: Colors.grey[200],
                    child: Center(child: Text("No Image Selected")),
                  ),
            SizedBox(height: 20),
            Text(
              _poseInfo,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // Buttons to pick an image from the gallery or capture a new one.
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  icon: Icon(Icons.photo),
                  label: Text("Gallery"),
                ),
                SizedBox(width: 20),
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera),
                  icon: Icon(Icons.camera),
                  label: Text("Capture Image"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
