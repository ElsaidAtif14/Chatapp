import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      action: SnackBarAction(label: 'OK', onPressed: () {}),
      duration: const Duration(milliseconds: 700),
      content: Text(message),
    ),
  );
}
