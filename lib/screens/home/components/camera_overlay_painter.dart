import 'package:flutter/material.dart';

class CameraOverlayPainter extends CustomPainter {
  final double linePosition; // This will hold the current position of the line

  CameraOverlayPainter(this.linePosition); // Constructor accepts linePosition

  @override
  void paint(Canvas canvas, Size size) {
    final double screenWidth = size.width+5;
    final double screenHeight = size.height;

    // Modify these values to match a typical barcode dimension
    const double rectHeight = 190; // Reduced height for barcode-like appearance
    final double rectWidth = screenWidth * 0.8; // Width is 80% of the screen width
    final double sideRectWidth = (screenWidth - rectWidth) / 2; // Adjust side rectangles accordingly

    final Paint paint = Paint()..color = Colors.black.withOpacity(0.5);
    final Paint linePaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2;

    // Calculate the top and bottom padding for the central rectangle
    final double topPadding = (screenHeight - rectHeight) / 2;
    final double bottomPadding = topPadding + rectHeight;

    // Rectangles around the central rectangle
    final Rect topRect = Rect.fromLTWH(0, 0, screenWidth, topPadding);
    final Rect bottomRect = Rect.fromLTWH(0, bottomPadding, screenWidth, screenHeight - bottomPadding);
    final Rect leftRect = Rect.fromLTWH(0, topPadding, sideRectWidth, rectHeight);
    final Rect rightRect = Rect.fromLTWH(screenWidth - sideRectWidth, topPadding, sideRectWidth, rectHeight);

    // Draw the rectangles
    canvas.drawRect(topRect, paint);
    canvas.drawRect(bottomRect, paint);
    canvas.drawRect(leftRect, paint);
    canvas.drawRect(rightRect, paint);

    // Draw the horizontal line at the dynamic position
    canvas.drawLine(
      Offset(sideRectWidth, topPadding + linePosition),
      Offset(screenWidth - sideRectWidth, topPadding + linePosition),
      linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}