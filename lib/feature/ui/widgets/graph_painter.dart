import 'package:flutter/material.dart';

class GraphPainter extends CustomPainter {
  late double leftOffsetStart;
  late double topOffsetEnd;
  late double drawingWidth;
  late double drawingHeight;
  int numberOfVerticalLines = 12;
  GraphPainter();
  @override
  void paint(Canvas canvas, Size size) {
    leftOffsetStart = size.width * 0.05;
    topOffsetEnd = size.height * 0.9;
    drawingWidth = size.width * 0.9;
    drawingHeight = topOffsetEnd;
    _drawVerticalLines(canvas);
  }

  void _drawVerticalLines(Canvas canvas) {
    double offsetStep = drawingWidth / (numberOfVerticalLines - 1);

    for (int line = 0; line < numberOfVerticalLines; line++) {
      final paint = Paint()
        ..color = Colors.grey.shade50
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      double yOffset = line * offsetStep;
      canvas.drawLine(
        Offset(
          leftOffsetStart + yOffset,
          drawingHeight,
        ),
        Offset(leftOffsetStart + yOffset, drawingHeight * .02),
        paint..color = Colors.grey,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
