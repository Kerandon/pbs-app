import 'package:flutter/material.dart';
import 'package:pbs_app/utils/enums/task_result.dart';
import 'package:pbs_app/utils/methods/pop_ups.dart';
import '../../utils/app_messages.dart';
import 'loading_page.dart';

class LoadingHelper extends StatelessWidget {
  const LoadingHelper({
    super.key,
    required this.future,
    this.onFutureComplete,
    this.text1,
    this.text2,
  });

  final Future<dynamic> future;
  final Function(TaskResult)? onFutureComplete;
  final String? text1, text2;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          Navigator.of(context).maybePop().then(
            (value) {
              onFutureComplete?.call(TaskResult.failFirebase);
            },
          );
        }
        if (snapshot.hasData) {
          if (snapshot.data == TaskResult.failFirebase ||
              snapshot.data == TaskResult.failHttp) {
            showSnackBarMessage(context, AppMessages.errorFirebaseConnection);
          }
          Navigator.maybePop(context)
              .then((value) => {onFutureComplete!.call(snapshot.data)});
        }
        return LoadingPage(
          text1: text1,
          text2: text2,
        );
      },
    );
  }
}
