import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'package:flutter/services.dart';
import '../widgets/result_display.dart';

class LivePoseDetector extends StatefulWidget {
  @override
  _LivePoseDetectorState createState() => _LivePoseDetectorState();
}

class _LivePoseDetectorState extends State<LivePoseDetector> {
  CameraController? _cameraController;
  late List<CameraDescription> _cameras;
  tfl.Interpreter? _interpreter;
  String _detectedPose = "No pose detected";
  double _confidence = 0.0;
  bool _isDetecting = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _loadModel();
  }

  /// 📸 Initialize Camera
  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      _cameraController = CameraController(
        _cameras[0], // Use first available camera
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _cameraController!.initialize();
      if (!mounted) return;

      setState(() {});

      _cameraController!.startImageStream((CameraImage image) {
        if (!_isDetecting) {
          _isDetecting = true;
          _detectPose(image).then((_) {
            Future.delayed(Duration(milliseconds: 200), () { // 🔹 Add delay
              _isDetecting = false;
            });
          });
        }
      });
    } catch (e) {
      print("❌ Error initializing camera: $e");
    }
  }

  /// ✅ Fix Camera Rotation
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  /// ✅ Load TensorFlow Lite Model
  Future<void> _loadModel() async {
    try {
      _interpreter = await tfl.Interpreter.fromAsset("assets/yoga_pose_classifier.tflite");
      print("✅ Model loaded successfully!");
    } catch (e) {
      print("❌ Error loading model: $e");
    }
  }

  /// 🤖 Run Pose Detection on Live Camera Frame
  Future<void> _detectPose(CameraImage image) async {
    if (_interpreter == null) return;
    if (!mounted) return; // 🔹 Prevent running inference if widget is removed

    try {
      // 📏 Preprocess Image (Resize & Normalize)
      List<List<List<List<double>>>> input = _preprocessImage(image);

      // 📤 Prepare output buffer
      var output = List.filled(6, 0.0).reshape([1, 6]);

      print("✅ Running inference...");
      _interpreter!.run(input, output);

      // 🏆 Get highest confidence index
      int maxIndex = 0;
      double maxConfidence = 0.0;
      for (int i = 0; i < output[0].length; i++) { // 🔹 Fixed index
        if (output[0][i] > maxConfidence) {
          maxConfidence = output[0][i];
          maxIndex = i;
        }
      }

      List<String> poseLabels = ["Downdog", "Goddess", "Plank", "Tree", "Warrior2", "UnknownPose"];

      if (mounted) { // 🔹 Prevent calling setState() if widget is disposed
        setState(() {
          _detectedPose = poseLabels[maxIndex];
          _confidence = maxConfidence;
        });
      }

      print("🧘 Pose Detected: $_detectedPose (Confidence: ${(_confidence * 100).toStringAsFixed(1)}%)");
    } catch (e) {
      print("❌ Error detecting pose: $e");
    }
  }

  /// 📏 Preprocess Image (Resize & Normalize)
  List<List<List<List<double>>>> _preprocessImage(CameraImage image) {
    // Convert image to normalized tensor format
    return [
      List.generate(224, (_) => List.generate(224, (_) => List.generate(3, (_) => 0.0))) // Dummy Data
    ];
  }

  @override
  void dispose() {
    _cameraController?.stopImageStream(); // 🔹 Stop image stream
    _cameraController?.dispose(); // 🔹 Properly release camera
    _interpreter?.close(); // 🔹 Free up TFLite model
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Live Pose Detection")),
      body: Column(
        children: [
          // 🎥 Camera Preview
          _cameraController != null && _cameraController!.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _cameraController!.value.aspectRatio,
                  child: CameraPreview(_cameraController!),
                )
              : Center(child: CircularProgressIndicator()),

          SizedBox(height: 20),

          // ✅ Display Pose Detection Result
          ResultDisplay(poseName: _detectedPose, accuracy: _confidence),
        ],
      ),
    );
  }
}
