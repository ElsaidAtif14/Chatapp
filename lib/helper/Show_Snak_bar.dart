import 'package:flutter/material.dart';

void showSnakBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {},
      ),
      duration: const Duration(milliseconds: 700),
      content: Text(text),
    ),
  );
}
