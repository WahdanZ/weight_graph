import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:weight_graph/feature/weight_chart/presentation/widgets/bottom_sheet_done_button.dart';

void showAppSheetBottomSheet(
  BuildContext context, {
  required Widget child,
  required VoidCallback onClicked,
}) =>
    kIsWeb || Platform.isIOS
        ? showCupertinoModalPopup(
            context: context,
            builder: (context) => CupertinoActionSheet(
              actions: [
                child,
              ],
              cancelButton: CupertinoActionSheetAction(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      '+ Add Weight',
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
                onPressed: onClicked,
              ),
            ),
          )
        : showModalBottomSheet(
            context: context,
            builder: (context) => Column(
              children: [
                Expanded(child: child),
                BottomSheetDoneButton(
                  onClicked: onClicked,
                )
              ],
            ),
          );
List<Widget> modelBuilder<M>(
        List<M> models, Widget Function(int index, M model) builder) =>
    models
        .asMap()
        .map<int, Widget>(
            (index, model) => MapEntry(index, builder(index, model)))
        .values
        .toList();
