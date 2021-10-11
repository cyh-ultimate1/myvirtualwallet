import 'package:flutter/material.dart';

class Helpers {
  static void displayDialog(context, title, text,
      {List<Widget>? widgets}) =>
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(text),
          actions: widgets,
        ),
      );
}
