import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'yoga_pose_classifier.dart';

class ImagePoseDetector extends StatefulWidget {
  @override
  _ImagePoseDetectorState createState() => _ImagePoseDetectorState();
}

class _ImagePoseDetectorState extends State<ImagePoseDetector> {
  File? _image;
  String _poseLabel = "No pose detected";
  final ImagePicker _picker = ImagePicker();
  late YogaPoseClassifier _classifier;

  @override
  void initState() {
    super.initState();
    _classifier = YogaPoseClassifier();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _poseLabel = "Processing...";
      });

      // Convert image to processable format
      img.Image? image = img.decodeImage(await _image!.readAsBytes());

      if (image == null) {
        setState(() {
          _poseLabel = "Error: Unable to process image!";
        });
        return;
      }

      // Classify pose
      String result = _classifier.classifyPose(image);

      setState(() {
        _poseLabel = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload Image for Pose Detection")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_image != null) Image.file(_image!, height: 300),
          SizedBox(height: 20),
          Text(_poseLabel, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _pickImage,
            child: Text("Pick Image"),
          ),
        ],
      ),
    );
  }
}
