import 'package:flutter/material.dart';

Future<Widget> pushReplacementRoute(
    {required BuildContext context, required Widget destination}) async {
  return await Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (context) => destination));
}
