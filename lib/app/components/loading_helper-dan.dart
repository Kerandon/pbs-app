
import 'package:flutter/material.dart';

class LoadingHelperDan extends StatelessWidget {
  const LoadingHelperDan({Key? key, required this.future}) : super(key: key);

  final Future<dynamic> future;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.hasError) {
              return Container(color:Colors.red,);
            }
            pop(context);
          }

          return Container(color:Colors.teal,);
        });
  }

  Future<void> pop(BuildContext context) async {
    final bool popped = await Navigator.maybePop(context);
    if (popped == true) {
      await Navigator.maybePop(context);
    }
  }
}
