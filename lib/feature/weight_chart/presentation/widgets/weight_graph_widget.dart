import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:weight_graph/feature/weight_chart/presentation/index.dart';
import 'package:weight_graph/styles/app_colors.dart';

class WeightGraphWidget extends StatefulWidget {
  final List<WeightEntity> wights;

  const WeightGraphWidget({Key? key, required this.wights}) : super(key: key);

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
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final itemsWidth = widget.wights.length * 60;
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        scrollbars: true,
        physics: const BouncingScrollPhysics(),
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        },
      ),
      child: SingleChildScrollView(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(
              //maxWidth: itemsWidth < width ? width : itemsWidth.toDouble(),
              minWidth: itemsWidth < width ? width : itemsWidth.toDouble(),
              minHeight: height),
          child: Padding(
            padding: const EdgeInsets.only(right: 90, left: 10),
            child: CustomPaint(
              painter: GraphPainter(
                  items: widget.wights, lineColor: AppColors.graphLineColor),
            ),
          ),
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
