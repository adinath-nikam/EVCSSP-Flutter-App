import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: color,
      content: Text(
    text,
  )));
}
