import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../configs/app_colors.dart';
import '../../configs/ui_constants.dart';

class FlairBox extends StatefulWidget {
  const FlairBox({
    super.key,
    required this.text,
    this.iconData,
    this.onPressed,
  });

  final String text;
  final IconData? iconData;
  final VoidCallback? onPressed;

  @override
  State<FlairBox> createState() => _FlairBoxState();
}

class _FlairBoxState extends State<FlairBox> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(kBorderRadius),
          child: Material(
            color: AppColors.middleBlue,
            child: InkWell(
              onTap: () {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  widget.onPressed?.call();
                });
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(size.width * 0.05,
                    size.width * 0.01, size.width * 0.05, size.width * 0.01),
                child: Row(
                  children: [
                    widget.iconData != null
                        ? Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: FaIcon(
                              widget.iconData!,
                              size: 12,
                            ),
                          )
                        : const SizedBox(),
                    Text(widget.text, style: Theme.of(context).textTheme.displaySmall,),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
