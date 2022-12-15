import 'package:flutter/material.dart';

import 'error_screen.dart';
import 'loading_screen.dart';

class LoadingHelper extends StatelessWidget {
  const LoadingHelper({
    super.key,
    required this.future,
    required this.onFutureComplete,
  });

  final Future<dynamic> future;
  final VoidCallback onFutureComplete;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const ErrorScreen();
        }
        if (snapshot.hasData) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            onFutureComplete.call();
          });
        }
        return const LoadingScreen();
      },
    );
  }
}
