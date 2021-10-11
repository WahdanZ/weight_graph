import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weight_graph/utils/bottom_sheet.dart';

class NumberPicker extends StatefulWidget {
  final int min;
  final int max;
  final String type;
  final ValueChanged<int>? onSelectedItemChanged;

  const NumberPicker(
      {Key? key,
      this.min = 0,
      this.max = 100,
      this.type = "",
      this.onSelectedItemChanged})
      : assert(max > min),
        super(key: key);

  @override
  State<NumberPicker> createState() => _NumberPickerState();
}

class _NumberPickerState extends State<NumberPicker> {
  int index = 0;
  late final List<int> values;
  @override
  void initState() {
    values = List.generate(widget.max - widget.min, (index) => index + 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPicker(
      itemExtent: 30,
      looping: true,
      onSelectedItemChanged: (index) =>
          widget.onSelectedItemChanged?.call(values[index]),
      children: modelBuilder<int>(
        values,
        (index, value) {
          return Center(
            child: Text(
              "$value ${widget.type}",
            ),
          );
        },
      ),
    );
  }
}
