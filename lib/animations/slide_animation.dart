import 'package:flutter/material.dart';

class SlideAnimation extends StatefulWidget {
  const SlideAnimation(
      {Key? key,
        required this.child,
      })
      : super(key: key);

  final Widget child;

  @override
  State<SlideAnimation> createState() => _SlideAnimationState();
}

class _SlideAnimationState extends State<SlideAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
    _slide = Tween<Offset>(begin: const Offset(0, 1), end: const Offset(0, 0)).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SlideTransition(
      position: _slide,
      child: Container(
        width: size.width,
        height: size.height,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: widget.child,
        ),
      ),
    );
  }
}
