import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class LivePoseDetector extends StatefulWidget {
  @override
  _LivePoseDetectorState createState() => _LivePoseDetectorState();
}

class _LivePoseDetectorState extends State<LivePoseDetector> {
  CameraController? _cameraController;
  late Interpreter _interpreter;
  bool _isDetecting = false;
  String _poseResult = "No pose detected";
  late PoseDetector _poseDetector;

  final List<String> _poses = ["Downdog", "Goddess", "Plank", "Tree", "Warrior2"];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _loadModel();
    _poseDetector = PoseDetector(options: PoseDetectorOptions());
  }

  // Load TensorFlow Lite model
  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset("assets/yoga_pose_classifier.tflite");
      print("✅ Model loaded successfully");
    } catch (e) {
      print("❌ Error loading model: $e");
    }
  }

  // Initialize Camera
  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _cameraController = CameraController(cameras[0], ResolutionPreset.medium);
    
    await _cameraController!.initialize();
    if (!mounted) return;
    setState(() {});

    _cameraController!.startImageStream((CameraImage image) {
      if (!_isDetecting) {
        _isDetecting = true;
        _processImage(image).then((_) => _isDetecting = false);
      }
    });
  }

  // Process camera image and run pose detection
  Future<void> _processImage(CameraImage image) async {
    try {
      final InputImage inputImage = _convertCameraImageToInputImage(image);
      final List<Pose> poses = await _poseDetector.processImage(inputImage);

      if (poses.isNotEmpty) {
        _classifyPose(poses.first);
      }
    } catch (e) {
      print("❌ Error processing image: $e");
    }
  }

  // Convert CameraImage to InputImage
  InputImage _convertCameraImageToInputImage(CameraImage image) {
    return InputImage.fromBytes(
      bytes: image.planes[0].bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: InputImageRotation.rotation0deg,
        format: InputImageFormat.nv21,
        bytesPerRow: image.planes[0].bytesPerRow,
      ),
    );
  }

  // Run classification on detected pose
  Future<void> _classifyPose(Pose pose) async {
    try {
      var input = _extractPoseLandmarks(pose);
      var output = List.filled(5, 0.0).reshape([1, 5]);

      _interpreter.run(input, output);

      setState(() {
        int maxIndex = output[0].indexWhere((element) => element == output[0].reduce((a, b) => a > b ? a : b));
        _poseResult = "${_poses[maxIndex]} (Confidence: ${(output[0][maxIndex] * 100).toStringAsFixed(1)}%)";
      });

      print("📊 Model Output: $output");
    } catch (e) {
      print("❌ Classification Error: $e");
    }
  }

  // Extract pose landmarks (Placeholder - Replace with actual processing)
  List<double> _extractPoseLandmarks(Pose pose) {
    // Placeholder function - Extract and normalize key points
    return List.filled(3, 0.0); // Dummy input, adjust based on your model
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _poseDetector.close();
    _interpreter.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Live Pose Detector")),
      body: Stack(
        children: [
          _cameraController == null || !_cameraController!.value.isInitialized
              ? Center(child: CircularProgressIndicator())
              : CameraPreview(_cameraController!),
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                _poseResult,
                style: TextStyle(fontSize: 18, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
