import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ConfirmationBox extends StatelessWidget {
  const ConfirmationBox({
    Key? key,
    required this.title,
    required this.voidCallBack,
  }) : super(key: key);

  final String title;
  final VoidCallback voidCallBack;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title, style: Theme.of(context).textTheme.headlineSmall,
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [

        IconButton(
            onPressed: () async {
              await Navigator.maybePop(context);
            },
            icon: const Icon(Icons.check),),
        IconButton(onPressed: voidCallBack, icon: const Icon(Icons.close),),
      ],
    );
  }
}