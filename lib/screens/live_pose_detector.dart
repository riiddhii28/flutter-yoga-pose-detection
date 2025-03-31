import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'dart:math' as math;
import '../widgets/skeleton_overlay.dart';

class LivePoseDetector extends StatefulWidget {
  @override
  _LivePoseDetectorState createState() => _LivePoseDetectorState();
}

class _LivePoseDetectorState extends State<LivePoseDetector> {
  CameraController? _cameraController;
  bool _isDetecting = false;
  tfl.Interpreter? _movenetInterpreter;
  tfl.Interpreter? _classifierInterpreter;
  List<List<double>> keypoints = [];
  String _poseResult = "No Pose Detected";

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _loadModels();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final backCamera = cameras.first;

    _cameraController = CameraController(backCamera, ResolutionPreset.medium);
    await _cameraController!.initialize();
    if (!mounted) return;

    setState(() {});
    _startPoseDetection();
  }

  Future<void> _loadModels() async {
    try {
      _movenetInterpreter =
          await tfl.Interpreter.fromAsset('assets/movenet_thunder.tflite');
      _classifierInterpreter =
          await tfl.Interpreter.fromAsset('assets/yoga_pose_classifier.tflite');
      print("✅ TFLite Models Loaded!");
    } catch (e) {
      print("❌ Error loading models: $e");
    }
  }

  void _startPoseDetection() {
    _cameraController?.startImageStream((CameraImage image) {
      if (!_isDetecting) {
        _isDetecting = true;
        _runPoseDetection(image).then((_) => _isDetecting = false);
      }
    });
  }

  Future<void> _runPoseDetection(CameraImage image) async {
    if (_movenetInterpreter == null || _classifierInterpreter == null) return;

    try {
      img.Image convertedImage = _convertCameraImage(image);
      Float32List input = _processImage(convertedImage);

      List<List<double>> output =
          List.generate(1, (index) => List.filled(17 * 3, 0.0));
      _movenetInterpreter!.run(input, output);

      setState(() {
        keypoints = output;
        _poseResult = _classifyPose(output);
      });
    } catch (e) {
      print("❌ Error in pose detection: $e");
    }
  }

  String _classifyPose(List<List<double>> keypoints) {
    if (_classifierInterpreter == null) return "Model Not Loaded";

    List<List<double>> output =
        List.generate(1, (index) => List.filled(5, 0.0));
    _classifierInterpreter!.run(keypoints, output);

    List<String> poseLabels = [
      "Downdog",
      "Goddess",
      "Plank",
      "Tree",
      "Warrior2"
    ];
    int maxIndex = output[0].indexOf(output[0].reduce(math.max));

    return poseLabels[maxIndex];
  }

  /// Converts YUV420 CameraImage to an RGB `img.Image`
  img.Image _convertCameraImage(CameraImage image) {
    final int width = image.width;
    final int height = image.height;
    img.Image imgBuffer = img.Image(width: width, height: height);

    final Uint8List yBuffer = image.planes[0].bytes;
    final Uint8List uBuffer = image.planes[1].bytes;
    final Uint8List vBuffer = image.planes[2].bytes;

    final int uvRowStride = image.planes[1].bytesPerRow;
    final int uvPixelStride = image.planes[1].bytesPerPixel!;

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final int uvIndex = uvPixelStride * (x ~/ 2) + uvRowStride * (y ~/ 2);
        final int index = y * width + x;

        final int yPixel = yBuffer[index];
        final int uPixel = uBuffer[uvIndex] - 128;
        final int vPixel = vBuffer[uvIndex] - 128;

        int r = (yPixel + 1.402 * vPixel).round();
        int g = (yPixel - 0.344136 * uPixel - 0.714136 * vPixel).round();
        int b = (yPixel + 1.772 * uPixel).round();

        r = r.clamp(0, 255);
        g = g.clamp(0, 255);
        b = b.clamp(0, 255);

        imgBuffer.setPixel(x, y, img.ColorInt8.rgb(r, g, b));
      }
    }

    return img.copyResize(imgBuffer, width: 192, height: 192);
  }

  /// Converts `img.Image` to Float32List for TFLite input
  Float32List _processImage(img.Image image) {
    img.Image grayscaleImage = img.grayscale(image);
    List<int> pixels = grayscaleImage.getBytes(order: img.ChannelOrder.rgb);

    return Float32List.fromList(pixels.map((p) => p / 255.0).toList());
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _movenetInterpreter?.close();
    _classifierInterpreter?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Live Pose Detection")),
      body: _cameraController == null || !_cameraController!.value.isInitialized
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                CameraPreview(_cameraController!),
                SkeletonOverlay(keypoints: keypoints), 
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    color: Colors.black54,
                    child: Text(
                      _poseResult,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
