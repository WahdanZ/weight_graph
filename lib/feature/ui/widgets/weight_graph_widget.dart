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
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return SizedBox(
      width: width / 2,
      height: height / 2,
      child: CustomPaint(
        painter: GraphPainter(),
      ),
    );
  }
}
