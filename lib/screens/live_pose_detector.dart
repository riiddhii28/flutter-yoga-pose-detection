import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

class LivePoseDetector extends StatefulWidget {
  @override
  _LivePoseDetectorState createState() => _LivePoseDetectorState();
}

class _LivePoseDetectorState extends State<LivePoseDetector> {
  CameraController? _cameraController;
  late List<CameraDescription> _cameras;
  tfl.Interpreter? _interpreter;
  String _detectedPose = "No Pose Detected";
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
            Future.delayed(Duration(milliseconds: 300), () { 
              _isDetecting = false;
            });
          });
        }
      });
    } catch (e) {
      print("❌ Error initializing camera: $e");
    }
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
    if (_interpreter == null || !mounted) return;

    try {
      List<List<List<List<double>>>> input = _preprocessImage(image);
      var output = List.filled(6, 0.0).reshape([1, 6]);

      print("✅ Running inference...");
      _interpreter!.run(input, output);
      print("📊 Model Output: $output");

      int maxIndex = 0;
      double maxConfidence = 0.0;

      // ✅ Find the highest confidence value
      for (int i = 1; i < output[0].length; i++) {
        if (output[0][i] > maxConfidence) {
          maxConfidence = output[0][i];
          maxIndex = i - 1;
        }
      }

      List<String> poseLabels = ["Downdog", "Goddess", "Plank", "Tree", "Warrior2", "UnknownPose"];

      String detectedPose;
      
      // ✅ If confidence is very low (<10%), show "No Pose Detected"
      if (maxConfidence < 0.1) {
        detectedPose = "No Pose Detected";
        maxConfidence = 0.0;
      } 
      // ✅ If confidence is below 60%, classify as "Unknown Pose"
      else if (maxConfidence < 0.6) {
        detectedPose = "Unknown Pose";
      } 
      // ✅ Otherwise, use the detected pose
      else {
        detectedPose = poseLabels[maxIndex];
      }

      if (mounted) {
        setState(() {
          _detectedPose = detectedPose;
          _confidence = maxConfidence;
        });
      }

      print("🧘 Pose Detected: $_detectedPose (Confidence: ${(_confidence * 100).toStringAsFixed(1)}%)");
    } catch (e) {
      print("❌ Error detecting pose: $e");
    }
  }

  /// 📏 Preprocess Image (Convert & Normalize)
  List<List<List<List<double>>>> _preprocessImage(CameraImage image) {
    try {
      img.Image imgImage = _convertYUV420ToImage(image);
      img.Image resizedImage = img.copyResize(imgImage, width: 224, height: 224);

      List<List<List<List<double>>>> input = [
        List.generate(
          224,
          (y) => List.generate(
            224,
            (x) {
              img.Color pixel = resizedImage.getPixel(x, y);
              return [
                pixel.r / 255.0,
                pixel.g / 255.0,
                pixel.b / 255.0
              ];
            },
          ),
        )
      ];
      return input;
    } catch (e) {
      print("❌ Error preprocessing image: $e");
      return [
        List.generate(224, (_) => List.generate(224, (_) => List.generate(3, (_) => 0.0)))
      ];
    }
  }

  /// 🖼 Convert CameraImage (YUV420) to RGB Image
  img.Image _convertYUV420ToImage(CameraImage image) {
    int width = image.width;
    int height = image.height;

    var yBuffer = image.planes[0].bytes;
    var uBuffer = image.planes[1].bytes;
    var vBuffer = image.planes[2].bytes;

    var imgData = img.Image(width: width, height: height);

    int yIndex = 0;
    int uvIndex = 0;

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        int yValue = yBuffer[yIndex++] & 0xFF;
        int uValue = uBuffer[uvIndex] & 0xFF;
        int vValue = vBuffer[uvIndex] & 0xFF;
        if (x % 2 == 1) uvIndex++;

        int r = (yValue + 1.370705 * (vValue - 128)).clamp(0, 255).toInt();
        int g = (yValue - 0.698001 * (vValue - 128) - 0.337633 * (uValue - 128)).clamp(0, 255).toInt();
        int b = (yValue + 1.732446 * (uValue - 128)).clamp(0, 255).toInt();

        imgData.setPixelRgb(x, y, r, g, b);
      }
    }
    return imgData;
  }

  @override
  void dispose() {
    _cameraController?.stopImageStream();
    _cameraController?.dispose();
    _interpreter?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Live Pose Detection")),
      body: Stack(
        children: [
          // 🎥 Camera Preview (Full Screen)
          Positioned.fill(
            child: _cameraController != null && _cameraController!.value.isInitialized
                ? CameraPreview(_cameraController!)
                : Center(child: CircularProgressIndicator()),
          ),

          // 📊 Overlay for Pose Detection Result
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _detectedPose,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 10),
                Text(
                  _confidence > 0 ? "Confidence: ${(_confidence * 100).toStringAsFixed(1)}%" : "",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
