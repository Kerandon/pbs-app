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
        title,
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        IconButton(onPressed: voidCallBack, icon: const Icon(FontAwesomeIcons.check, color: Colors.amber, size: 30,)),
        IconButton(
            onPressed: () async {
              await Navigator.maybePop(context);
            },
            icon: const Icon(FontAwesomeIcons.xmark, color: Colors.red, size: 30,))
      ],
    );
  }
}