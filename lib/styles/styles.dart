import 'package:flutter/material.dart';

const buttonTextStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);

rounderButtonStyle(Color color) => OutlinedButton.styleFrom(
    side: BorderSide.none,
    backgroundColor: color,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.5)));
const labelTextStyle = TextStyle(
    decoration: TextDecoration.none,
    fontSize: 20,
    color: Colors.black,
    fontWeight: FontWeight.w600);
