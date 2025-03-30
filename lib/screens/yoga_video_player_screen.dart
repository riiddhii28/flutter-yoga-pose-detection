import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class YogaVideoPlayerScreen extends StatefulWidget {
  final String videoPath;

  YogaVideoPlayerScreen(this.videoPath);

  @override
  _YogaVideoPlayerScreenState createState() => _YogaVideoPlayerScreenState();
}

class _YogaVideoPlayerScreenState extends State<YogaVideoPlayerScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    // Load the video from assets instead of a network URL
    _controller = VideoPlayerController.asset(widget.videoPath)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Yoga Course Video")),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
