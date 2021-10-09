import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:weight_graph/feature/ui/widgets/graph_painter.dart';

import 'graph_entity.dart';

class WeightGraphWidget extends StatefulWidget {
  const WeightGraphWidget({Key? key}) : super(key: key);

  @override
  _WeightGraphWidgetState createState() => _WeightGraphWidgetState();
}

class _WeightGraphWidgetState extends State<WeightGraphWidget> {
  @override
  Widget build(BuildContext context) {
    final _items = List.generate(
        20,
        (index) => GraphEntity(
              Random().nextInt(100).toDouble(),
              DateTime(2021, 10, index + 1),
            ));
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        scrollbars: true,
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        },
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            SizedBox(
              width: _items.length * 40,
              height: height / 2,
              child: CustomPaint(
                painter: GraphPainter(items: _items),
              ),
            ),
            const SizedBox(
              width: 60,
            )
          ],
        ),
      ),
    );
  }
}
