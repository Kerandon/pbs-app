import 'package:flutter/material.dart';

import 'error_page.dart';
import 'loading_page.dart';

class LoadingHelper extends StatefulWidget {
  const LoadingHelper({
    super.key,
    required this.future,
    this.onFutureComplete,
  });

  final Future<dynamic> future;
  final VoidCallback? onFutureComplete;

  @override
  State<LoadingHelper> createState() => _LoadingHelperState();
}

class _LoadingHelperState extends State<LoadingHelper> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: widget.future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print('data is ${snapshot.data.toString()}');
          if (snapshot.hasError) {
            return const ErrorPage();
          }

          WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
            widget.onFutureComplete?.call();
            await pop(context);
          });
        }
        return const LoadingPage();
      },
    );
  }

  Future<void> pop(BuildContext context) async {
    Builder(
      builder: (context) {
        Navigator.of(context).maybePop();
        return const SizedBox();
      },
    );
  }
}
