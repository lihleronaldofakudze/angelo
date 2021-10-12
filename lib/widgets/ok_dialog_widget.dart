import 'package:flutter/material.dart';

AlertDialog okDialogWidget(
    {required BuildContext context, required String message}) {
  return AlertDialog(
    title: Text(
      'Angelo',
      style: TextStyle(fontSize: 20, color: Colors.teal),
    ),
    content: Text(
      message,
      style: TextStyle(fontSize: 20, color: Colors.teal),
    ),
    actions: [
      TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Ok', style: TextStyle(fontSize: 20, color: Colors.teal)))
    ],
  );
}
