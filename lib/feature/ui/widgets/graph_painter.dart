import 'dart:math';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart' hide TextStyle;
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:weight_graph/feature/ui/widgets/graph_entity.dart';

class GraphPainter extends CustomPainter {
  late double leftOffsetStart;
  late double topOffsetEnd;
  late double drawingWidth;
  late double drawingHeight;
  int numberOfVerticalLines = 5;
  int numberOfHorizontalLabels = 6;
  late final double minValue;
  late final double maxValue;
  late final List<GraphEntity> _items;
  GraphPainter({
    List<GraphEntity> items = const [],
  }) {
    _items = items;
    if (_items.isNotEmpty && _items.length > 1) {
      _items.sort((l, r) => l.dateTime.compareTo(r.dateTime));
      _items.toSet();
      maxValue = _items.map((e) => e.value).reduce(max);
      minValue = _items.map((e) => e.value).reduce(min);
    } else {
      maxValue = _items.firstOrNull?.value ?? 0.0;
      minValue = _items.firstOrNull?.value ?? 0.0;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    leftOffsetStart = size.width * 0.10;
    topOffsetEnd = size.height * 0.9;
    drawingWidth = size.width * 0.9;
    drawingHeight = topOffsetEnd;

    numberOfVerticalLines =
        _items.map((e) => e.dateTime).toSet().toList().length;
    _drawVerticalLines(canvas);

    _drawBottomLabels(canvas);
    _drawLeftLabels(canvas, size);
    _drawHorizontalLine(canvas, size);
    _drawLines(canvas);
    _drawCircle(canvas);
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
      tp.paint(canvas, Offset(offsetX - 10, 10.0 + drawingHeight));
    }
  }

  void _drawVerticalLines(Canvas canvas) {
    double offsetStep = drawingWidth / (numberOfVerticalLines - 1);

    for (int line = 0; line < numberOfVerticalLines; line++) {
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

  void _drawLeftLabels(Canvas canvas, Size size) {
    double yOffsetStep = _getYOffsetStep();
    int lineStep = _getLineStep();
    print("maxValue $maxValue , maxValue $minValue");

    print("LineStep  $lineStep");
    for (int line = 0; line < numberOfHorizontalLabels; line++) {
      double yOffset = line * yOffsetStep;
      TextSpan span = TextSpan(
          style: const TextStyle(color: Colors.grey, fontSize: 10),
          text: "${(maxValue - (line * lineStep)).toInt()}");
      TextPainter tp = TextPainter(
          text: span,
          textAlign: TextAlign.right,
          textDirection: TextDirection.ltr);
      tp.layout(maxWidth: 20);
      tp.paint(canvas, Offset(leftOffsetStart - 20, yOffset + 5));
      //   _drawHorizontalLine(canvas, yOffset + 5, size);
    }
  }

  void _drawHorizontalLine(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    double dashWidth = 9, dashSpace = 5, startX = leftOffsetStart;

    while (startX < size.width) {
      canvas.drawLine(Offset(startX, drawingHeight / 2),
          Offset(startX + dashWidth, drawingHeight / 2), paint);
      startX += dashWidth + dashSpace;
    }
  }

  void _drawLines(
    Canvas canvas,
  ) {
    final paint = Paint()
      ..color = Colors.green
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;
    int lineStep = _getLineStep();
    double yOffsetStep = _getYOffsetStep();

    double offsetStep = drawingWidth / (numberOfVerticalLines - 1);
    for (int i = 0; i < _items.length - 1; i++) {
      double yOffset =
          _getYOffsetOfPoint(_items[i].value, lineStep, yOffsetStep);
      double yOffset2 =
          _getYOffsetOfPoint(_items[i + 1].value, lineStep, yOffsetStep);
      Offset startEntryOffset = Offset(
        leftOffsetStart + offsetStep * i,
        yOffset,
      );
      Offset endEntryOffset = Offset(
        leftOffsetStart + (offsetStep * (i + 1)),
        yOffset2,
      );
      canvas.drawLine(startEntryOffset, endEntryOffset, paint);
    }
  }

  void _drawCircle(
    Canvas canvas,
  ) {
    final paint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    final paintC = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white
      ..strokeWidth = 3.0;
    int lineStep = _getLineStep();
    double yOffsetStep = _getYOffsetStep();

    double offsetStep = drawingWidth / (numberOfVerticalLines - 1);
    for (int i = 0; i < _items.length; i++) {
      double yOffset =
          _getYOffsetOfPoint(_items[i].value, lineStep, yOffsetStep);
      Offset endEntryOffset = Offset(
        leftOffsetStart + (offsetStep * (i)),
        yOffset,
      );
      canvas.drawCircle(endEntryOffset, 3.0, paint);
      canvas.drawCircle(endEntryOffset, 3.0, paintC);
    }
  }

  double _getYOffsetOfPoint(double value, int lineStep, double yOffsetStep) {
    double relativeYposition2 = (maxValue - value) / lineStep;
    return 8 + relativeYposition2 * yOffsetStep;
  }

  double _getYOffsetStep() =>
      (drawingHeight / (numberOfHorizontalLabels - 1)) - 3;

  int _getLineStep() =>
      ((maxValue - minValue) / (numberOfHorizontalLabels - 1)).ceil();

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return _items == _items;
  }
}
