import 'package:flutter/material.dart';
import 'package:pbs_app/utils/enums/task_result.dart';
import 'package:pbs_app/utils/methods/pop_ups.dart';
import '../../utils/app_messages.dart';
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

  late final _navigator;


  @override
  void didChangeDependencies() {
    _navigator = Navigator.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: widget.future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
            if (snapshot.hasError) {
              showSnackBarMessage(context, AppMessages.errorFirebaseConnection);
              widget.onFutureComplete?.call(TaskResult.failFirebase);
            } else {
              final result = snapshot.data as TaskResult;
              if (result == TaskResult.success) {
                await Navigator.maybePop(context).then((value) {
                  widget.onFutureComplete?.call(TaskResult.success);
                });

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

