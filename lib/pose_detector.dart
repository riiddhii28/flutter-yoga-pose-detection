import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class PoseDetectorScreen extends StatefulWidget {
  @override
  _PoseDetectorScreenState createState() => _PoseDetectorScreenState();
}

class _PoseDetectorScreenState extends State<PoseDetectorScreen> {
  late CameraController _cameraController;
  late Interpreter _interpreter;
  bool _isModelLoaded = false;
  String _detectedPose = "Detecting pose...";

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _loadModel();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _cameraController = CameraController(
      cameras[0], // Use first available camera
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _cameraController.initialize();
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _loadModel() async {
    _interpreter = await Interpreter.fromAsset('assets/yoga_pose_classifier.tflite');
    setState(() => _isModelLoaded = true);
  }

  Future<void> _captureAndClassifyPose() async {
    if (!_isModelLoaded || !_cameraController.value.isInitialized) return;

    final image = await _cameraController.takePicture();
    String pose = await classifyPose(image.path);
    
    setState(() {
      _detectedPose = pose;
    });
  }

  Future<String> classifyPose(String imagePath) async {
    Uint8List imageData = await _loadImageAsBytes(imagePath);
    img.Image? image = img.decodeImage(imageData);

    if (image == null) return "Unknown Pose";

    // Resize image to 224x224 for model input
    img.Image resizedImage = img.copyResize(image, width: 224, height: 224);

    List<List<List<double>>> input = List.generate(224, 
      (y) => List.generate(224, 
        (x) {
          var pixel = resizedImage.getPixel(x, y);
          return [(pixel.r / 255.0), (pixel.g / 255.0), (pixel.b / 255.0)];
        }
      )
    );

    var output = List.generate(1, (index) => List.filled(5, 0.0)); // 5 classes

    _interpreter.run([input], output);

    List<String> labels = ["Downdog", "Goddess", "Plank", "Tree", "Warrior2"];
    
    int maxIndex = output[0].indexOf(output[0].reduce((a, b) => a > b ? a : b));
    return labels[maxIndex];
  }

  Future<Uint8List> _loadImageAsBytes(String path) async {
    return await XFile(path).readAsBytes();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _interpreter.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Live Pose Detection")),
      body: Column(
        children: [
          if (_cameraController.value.isInitialized)
            Expanded(
              child: CameraPreview(_cameraController),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _detectedPose,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            onPressed: _captureAndClassifyPose,
            child: Text("Capture & Detect Pose"),
          ),
        ],
      ),
    );
  }
}
