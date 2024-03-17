import 'package:flutter/material.dart';

class DialogHelper {
  static void showCustomDialog({
    required BuildContext context,
    required String title,
    required Widget content,
    required List<Widget> actions,
  }) {
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: content,
      actions: actions,
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
