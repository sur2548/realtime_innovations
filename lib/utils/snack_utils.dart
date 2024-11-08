import 'package:flutter/material.dart';

class SnackUtils {
  SnackUtils._();

  static void error(BuildContext context, String error) {
    _show(context, SnackBar(content: Text(error), backgroundColor: Colors.red));
  }

  static void success(BuildContext context, String msg) {
    _show(context, SnackBar(content: Text(msg)));
  }

  static void action(
    BuildContext context,
    String msg,
    String label,
    VoidCallback onPressed,
  ) {
    _show(
      context,
      SnackBar(
        content: Text(msg),
        action: SnackBarAction(
          onPressed: onPressed,
          label: label,
        ),
      ),
    );
  }

  static void _show(BuildContext context, SnackBar snackBar) {
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
