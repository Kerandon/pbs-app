
import 'package:flutter/material.dart';

import '../../configs/ui_constants.dart';

class SubBanner extends StatelessWidget {
  const SubBanner({
    super.key,
    required this.contents,
  });

  final List<Widget> contents;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: size.height * 0.05,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kBorderRadius),
            color: Theme.of(context).secondaryHeaderColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: contents,
          ),
        ),
      ),
    );
  }
}
