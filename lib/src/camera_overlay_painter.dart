import 'package:flutter/material.dart';

class CameraOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double screenWidth = size.width;
    final double screenHeight = size.height;
    const double squareSize = 300; // Adjust square size as needed
    const double sideRectWidth = 32;

    final Paint paint = Paint()..color = Colors.white;
    final Rect topRect = Rect.fromLTWH(0, 0, screenWidth, (screenHeight - squareSize) / 2 +30);
    final Rect bottomRect = Rect.fromLTWH(0, (screenHeight + squareSize) / 2 +30, screenWidth, (screenHeight - squareSize) );
    final Rect leftRect = Rect.fromLTWH(0, ((screenHeight - squareSize) / 2) , sideRectWidth, screenHeight- squareSize);
    final Rect rightRect = Rect.fromLTWH(screenWidth - sideRectWidth, ((screenHeight - squareSize) / 2), sideRectWidth, screenHeight - squareSize);

    canvas.drawRect(topRect, paint);
    canvas.drawRect(bottomRect, paint);
    canvas.drawRect(leftRect, paint);
    canvas.drawRect(rightRect, paint);
  }

  @override
  bool shouldRepaint(CameraOverlayPainter oldDelegate) => false;
}