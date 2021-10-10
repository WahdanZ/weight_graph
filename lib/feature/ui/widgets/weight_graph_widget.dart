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
  late final ScrollController _controller;
  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _controller
          .animateTo(_controller.position.maxScrollExtent,
              duration: const Duration(seconds: 1), curve: Curves.ease)
          .then((value) async {
        await Future.delayed(const Duration(seconds: 2));
        _controller.animateTo(_controller.position.minScrollExtent,
            duration: const Duration(seconds: 1), curve: Curves.ease);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final _items = List.generate(
        20,
        (index) => GraphEntity(
              Random().nextInt(100).toDouble(),
              DateTime(2021, 10, Random().nextInt(30)),
            ));
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
        controller: _controller,
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            SizedBox(
              width: _items.length * 60,
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
