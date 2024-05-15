import 'package:flutter/material.dart';
import 'camera_overlay_painter.dart';
class CameraOverlay extends StatefulWidget {
  @override
  _CameraOverlayState createState() => _CameraOverlayState();
}

class _CameraOverlayState extends State<CameraOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true); // This makes the animation auto-reverse

    _animation = Tween<double>(begin: 0, end: 190).animate(_controller)
      ..addListener(() {
        setState(() {}); // Trigger rebuilds with the new value
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CameraOverlayPainter(_animation.value),
      child: Container(),  // Your camera feed widget would be here
    );
  }
}