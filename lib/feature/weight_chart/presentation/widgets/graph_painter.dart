import 'dart:math';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart' hide TextStyle;
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:weight_graph/feature/weight_chart/presentation/index.dart';
import 'package:weight_graph/utils/utils.dart';

class GraphPainter extends CustomPainter {
  late double leftOffsetStart;
  late double topOffsetEnd;
  late double drawingWidth;
  late double drawingHeight;
  final Color lineColor;
  int numberOfVerticalLines = 5;
  int numberOfHorizontalLabels = 6;
  late final double minValue;
  late final double maxValue;
  late final List<WeightEntity> _items;

  late List<DateTime> dates = [];
  GraphPainter(
      {List<WeightEntity> items = const [], this.lineColor = Colors.green}) {
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
    leftOffsetStart = size.width * 0.05;
    topOffsetEnd = size.height * 0.9;
    drawingWidth = size.width * 0.9;
    drawingHeight = topOffsetEnd;

    ;
    numberOfVerticalLines = _addMissingDates().length;
    _drawVerticalLines(canvas);

    _drawBottomLabels(canvas);
    _drawLeftLabels(canvas, size);
    _drawHorizontalLine(canvas, size);
    _drawLines(canvas);
    _drawCircle(canvas);
  }

  void _drawBottomLabels(Canvas canvas) {
    double offsetStep = getXOffsetStep();
    for (int i = 0; i <= dates.length - 1; i++) {
      double offsetX = leftOffsetStart + offsetStep * i;
      TextSpan span = TextSpan(
          style: const TextStyle(color: Colors.grey, fontSize: 10),
          text: formatDate(dates[i]));
      TextPainter tp = TextPainter(
          text: span,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, Offset(offsetX - 10, 10.0 + drawingHeight));
    }
  }

  void _drawVerticalLines(Canvas canvas) {
    double offsetStep = getXOffsetStep();
    final paint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    for (int line = 0; line < dates.length; line++) {
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

  double getXOffsetStep() => drawingWidth / (numberOfVerticalLines - 1);

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
    }
  }

  void _drawHorizontalLine(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    double dashWidth = 9, dashSpace = 5, startX = leftOffsetStart;
    final width = (numberOfVerticalLines) * getXOffsetStep();
    while (startX <= width) {
      canvas.drawLine(Offset(startX, drawingHeight / 2),
          Offset(startX + dashWidth, drawingHeight / 2), paint);
      startX += dashWidth + dashSpace;
    }
  }

  void _drawLines(
    Canvas canvas,
  ) {
    final paint = Paint()
      ..color = lineColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;
    int lineStep = _getLineStep();
    double yOffsetStep = _getYOffsetStep();

    double offsetStep = getXOffsetStep();
    for (int i = 0; i < _items.length - 1; i++) {
      double yOffset =
          _getYOffsetOfPoint(_items[i].value, lineStep, yOffsetStep);
      double xOffset =
          _getXOffsetOfPoint(_items[i].dateTime, lineStep, offsetStep);
      double xOffset2 =
          _getXOffsetOfPoint(_items[i + 1].dateTime, lineStep, offsetStep);
      double yOffset2 =
          _getYOffsetOfPoint(_items[i + 1].value, lineStep, yOffsetStep);
      Offset startEntryOffset = Offset(
        xOffset,
        yOffset,
      );
      Offset endEntryOffset = Offset(
        xOffset2,
        yOffset2,
      );
      canvas.drawLine(startEntryOffset, endEntryOffset, paint);
    }
  }

  void _drawCircle(
    Canvas canvas,
  ) {
    final paint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    final paintC = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white
      ..strokeWidth = 3.0;
    int lineStep = _getLineStep();
    double yOffsetStep = _getYOffsetStep();

    double offsetStep = getXOffsetStep();
    for (int i = 0; i < _items.length; i++) {
      double yOffset =
          _getYOffsetOfPoint(_items[i].value, lineStep, yOffsetStep);
      double xOffset =
          _getXOffsetOfPoint(_items[i].dateTime, lineStep, offsetStep);
      Offset endEntryOffset = Offset(
        xOffset,
        yOffset,
      );
      canvas.drawCircle(endEntryOffset, 3.0, paint);
      canvas.drawCircle(endEntryOffset, 3.0, paintC);
    }
  }

  double _getXOffsetOfPoint(DateTime value, int lineStep, double yOffsetStep) {
    int i = dates.indexWhere(
        (element) => element.day == value.day && element.year == value.year);
    return leftOffsetStart + yOffsetStep * i;
  }

  double _getYOffsetOfPoint(double value, int lineStep, double yOffsetStep) {
    if (lineStep == 0) {
      return 8;
    }
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

  List<DateTime> _addMissingDates() {
    var list = _items.map((e) => e.dateTime).toSet().toList();
    if (list.isEmpty && list.length < 2) return list;

    var result = <DateTime>[];
    DateTime startDate = list.first;
    for (int i = 0; i <= list.last.difference(startDate).inDays + 1; i++) {
      result.add(startDate.add(Duration(days: i)));
    }
    dates = result;
    return result;
  }
}
