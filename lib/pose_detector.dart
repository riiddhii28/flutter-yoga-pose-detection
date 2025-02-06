import 'dart:typed_data';
import 'dart:ui';


import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class PoseDetectorScreen extends StatefulWidget {
  @override
  _PoseDetectorScreenState createState() => _PoseDetectorScreenState();
}

class _PoseDetectorScreenState extends State<PoseDetectorScreen> {
  CameraController? _cameraController;
  late List<CameraDescription> _cameras;
  PoseDetector? _poseDetector;
  bool _isDetecting = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _poseDetector = PoseDetector(options: PoseDetectorOptions());
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    _cameraController = CameraController(_cameras[0], ResolutionPreset.medium);
    await _cameraController?.initialize();
    if (!mounted) return;
    setState(() {});
    _startPoseDetection();
  }

  void _startPoseDetection() {
    _cameraController?.startImageStream((CameraImage image) async {
      if (_isDetecting) return;
      _isDetecting = true;

      // Flatten the bytes from the camera image
      List<int> allBytes = [];
      for (Plane plane in image.planes) {
        allBytes.addAll(plane.bytes);
      }

      final inputImage = InputImage.fromBytes(
        bytes: Uint8List.fromList(allBytes),
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: InputImageRotation.rotation0deg,
          format: InputImageFormat.nv21,
          bytesPerRow: image.planes[0].bytesPerRow,
        ),
      );

      final poses = await _poseDetector!.processImage(inputImage);
      print("Detected ${poses.length} poses");

      setState(() {});
      _isDetecting = false;
    });
  }

  @override
  void dispose() {
    _poseDetector?.close();
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Live Pose Detection')),
      body: _cameraController != null && _cameraController!.value.isInitialized
          ? CameraPreview(_cameraController!)
          : Center(child: CircularProgressIndicator()),
    );
  }
}
