import 'package:flutter/material.dart';

Future<Widget?> pushReplacementRoute(
    BuildContext context, Widget destination) async {
  if (context.mounted) {
    return await Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => destination));
  }
  return null;
}
