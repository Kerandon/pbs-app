import 'package:flutter/material.dart';

void showSnackBarMessage(BuildContext context, String text) {
  if(context.mounted) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            text,
          ),
        ),
      );
    });

  }
}
