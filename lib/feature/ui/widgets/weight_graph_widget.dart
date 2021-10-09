import 'package:flutter/material.dart';
import 'package:weight_graph/feature/ui/widgets/graph_painter.dart';

class WeightGraphWidget extends StatefulWidget {
  const WeightGraphWidget({Key? key}) : super(key: key);

  @override
  _WeightGraphWidgetState createState() => _WeightGraphWidgetState();
}

class _WeightGraphWidgetState extends State<WeightGraphWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      height: 500,
      child: CustomPaint(
        painter: GraphPainter(),
      ),
    );
  }
}
