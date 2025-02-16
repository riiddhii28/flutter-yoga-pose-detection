import 'dart:async';
import 'dart:io';
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
  String _poseText = "No pose detected";

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _poseDetector = PoseDetector(options: PoseDetectorOptions());
  }

  /// Initializes the camera in portrait mode with high resolution
  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    final backCamera = _cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back);

    _cameraController = CameraController(
      backCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _cameraController?.initialize();
    if (!mounted) return;

    setState(() {});

    _startPoseDetection();
  }

  /// Starts real-time pose detection
  void _startPoseDetection() {
    _cameraController?.startImageStream((CameraImage image) async {
      if (_isDetecting) return;
      _isDetecting = true;

      final InputImageRotation rotation = InputImageRotation.rotation0deg;
      final inputImage = _convertCameraImageToInputImage(image, rotation);

      final poses = await _poseDetector!.processImage(inputImage);

      setState(() {
        _poseText = poses.isNotEmpty ? "Pose Detected: ${poses.length}" : "No pose detected";
      });

      _isDetecting = false;
    });
  }

  /// Converts camera image to MLKit format
  InputImage _convertCameraImageToInputImage(
      CameraImage image, InputImageRotation rotation) {
    final bytes = image.planes[0].bytes;
    final inputImage = InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: InputImageFormat.nv21,
        bytesPerRow: image.planes[0].bytesPerRow,
      ),
    );
    return inputImage;
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
          ? Stack(
              children: [
                CameraPreview(_cameraController!),
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(12),
                      color: Colors.black54,
                      child: Text(
                        _poseText,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
