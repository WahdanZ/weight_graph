import 'dart:math';

import 'package:flutter/material.dart' hide TextStyle;
import 'package:flutter/painting.dart';
import 'package:weight_graph/feature/ui/widgets/graph_entity.dart';

class GraphPainter extends CustomPainter {
  late double leftOffsetStart;
  late double topOffsetEnd;
  late double drawingWidth;
  late double drawingHeight;
  int numberOfVerticalLines = 5;
  int numberOfHorizontalLabels = 6;
  List<GraphEntity> _items;
  GraphPainter({
    List<GraphEntity> items = const [],
  }) : _items = items {
    _items = List.generate(
        6,
        (index) => GraphEntity(Random().nextInt(100).toDouble(),
            DateTime(2021, 10, Random().nextInt(20))));
    _items.sort((l, r) => l.dateTime.compareTo(r.dateTime));
  }

  @override
  void paint(Canvas canvas, Size size) {
    leftOffsetStart = size.width * 0.05;
    topOffsetEnd = size.height * 0.9;
    drawingWidth = size.width * 0.9;
    drawingHeight = topOffsetEnd;
    numberOfVerticalLines =
        _items.map((e) => e.dateTime).toSet().toList().length;

    _drawVerticalLines(canvas);
    _drawBottomLabels(canvas);
    _drawLeftLabels(canvas);
  }

  void _drawBottomLabels(Canvas canvas) {
    final dates = _items.map((e) => e.dateTime).toSet().toList();
    double offsetStep = drawingWidth / (numberOfVerticalLines - 1);
    for (int i = 0; i <= dates.length - 1; i++) {
      double offsetX = leftOffsetStart + offsetStep * i;
      TextSpan span = TextSpan(
          style: const TextStyle(color: Colors.grey, fontSize: 10),
          text: "${dates[i].day} / ${dates[i].month}");
      TextPainter tp = TextPainter(
          text: span,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, Offset(offsetX + offsetStep - 10, 10.0 + drawingHeight));
    }
  }

  void _drawVerticalLines(Canvas canvas) {
    double offsetStep = drawingWidth / (numberOfVerticalLines - 1);

    for (int line = 0; line < numberOfVerticalLines + 1; line++) {
      final paint = Paint()
        ..color = Colors.grey.shade200
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      double yOffset = line * offsetStep;
      canvas.drawLine(
          Offset(
            leftOffsetStart + yOffset,
            drawingHeight,
          ),
          Offset(leftOffsetStart + yOffset, drawingHeight * .02),
          paint);
    }
  }

  void _drawLeftLabels(Canvas canvas) {
    final maxValue = _items.map((e) => e.value).reduce(max);
    final minValue = _items.map((e) => e.value).reduce(min);
    print("maxValue $maxValue , maxValue $minValue");
    double yOffsetStep = (drawingHeight / (numberOfHorizontalLabels - 1)) - 3;
    int lineStep = (maxValue - minValue) ~/ (numberOfHorizontalLabels - 1);
    for (int line = 0; line < numberOfHorizontalLabels; line++) {
      double yOffset = line * yOffsetStep;
      TextSpan span = TextSpan(
          style: const TextStyle(color: Colors.grey, fontSize: 10),
          text: "${(maxValue - (line * lineStep)).toInt()}");
      TextPainter tp = TextPainter(
          text: span,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, Offset(0.0, yOffset + 5));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
