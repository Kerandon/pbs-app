import 'package:flutter/material.dart';

Future<Widget?> pushRoute(BuildContext context, Widget destination) async {
  if (context.mounted) {
    return await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => destination));
  }
  return null;
}

Future<Widget?> pushReplacementRoute(BuildContext context, Widget destination,
    {bool showMaterialTransition = false}) async {
  if (showMaterialTransition) {
    if (context.mounted) {
      return await Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => destination));
    }
  } else {
    Navigator.of(context).pushReplacement(
        PageRouteBuilder(pageBuilder: (_, __, ___) => destination));
  }

  return null;
}
