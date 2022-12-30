import 'package:flutter/material.dart';
import 'package:pbs_app/utils/enums/task_result.dart';
import 'loading_page.dart';

class LoadingHelper extends StatefulWidget {
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
  State<LoadingHelper> createState() => _LoadingHelperState();
}

class _LoadingHelperState extends State<LoadingHelper> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: widget.future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
            if (snapshot.hasError) {
              widget.onFutureComplete?.call(TaskResult.failFirebase);
            } else {
              final result = snapshot.data as TaskResult;
              if (result == TaskResult.success) {
                widget.onFutureComplete?.call(TaskResult.success);
              }
              if (result == TaskResult.failStudentAlreadyExists) {
                widget.onFutureComplete
                    ?.call(TaskResult.failStudentAlreadyExists);
              }
            }
          });
        }
        return LoadingPage(
          text1: widget.text1,
          text2: widget.text2,
        );
      },
    );
  }
}

// Future<void> pop(BuildContext context) async {
//   Builder(
//     builder: (context) {
//       Navigator.of(context).maybePop();
//       return const SizedBox();
//     },
//   );
// }
