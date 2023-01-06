import 'package:flutter/material.dart';

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
        style: Theme.of(context)
            .textTheme
            .headlineSmall!.copyWith(color: Colors.black),
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        IconButton(
          onPressed: () {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              voidCallBack.call();
            });


          },
          icon: const Icon(Icons.check, color: Colors.black, size: 30,),
        ),
        IconButton(
          onPressed: () async => await Navigator.maybePop(context),
          icon: const Icon(Icons.close, color: Colors.black, size: 30,),
        ),
      ],
    );
  }
}

