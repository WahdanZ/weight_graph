import 'package:flutter/material.dart';

class BottomSheetDoneButton extends StatelessWidget {
  final VoidCallback? onClicked;

  const BottomSheetDoneButton({Key? key, this.onClicked}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(minimumSize: const Size(100, 42)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.add, size: 28),
          SizedBox(width: 8),
          Text(
            '+ Add Weight',
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
      onPressed: onClicked,
    );
  }
}
