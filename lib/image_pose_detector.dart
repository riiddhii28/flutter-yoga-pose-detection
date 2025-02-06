import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class ImagePoseDetector extends StatefulWidget {
  @override
  _ImagePoseDetectorState createState() => _ImagePoseDetectorState();
}

class _ImagePoseDetectorState extends State<ImagePoseDetector> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  PoseDetector? _poseDetector;

  @override
  void initState() {
    super.initState();
    _poseDetector = PoseDetector(options: PoseDetectorOptions());
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _detectPose();
    }
  }

  Future<void> _detectPose() async {
    if (_image == null) return;

    final inputImage = InputImage.fromFile(_image!);
    final poses = await _poseDetector!.processImage(inputImage);

    print("Detected ${poses.length} poses in the image");
  }

  @override
  void dispose() {
    _poseDetector?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pose Detection from Image')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image != null ? Image.file(_image!) : Text('Select an Image'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick Image'),
            ),
          ],
        ),
      ),
    );
  }
}

