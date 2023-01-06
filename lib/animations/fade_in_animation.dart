import 'package:flutter/material.dart';

class FadeInAnimation extends StatefulWidget {
  const FadeInAnimation(
      {Key? key, required this.child, this.duration = 400, this.scaleStart = 0.90, this.fadeStart = 0.50})
      : super(key: key);

  final Widget child;
  final int duration;
  final double scaleStart;
  final double fadeStart;

  @override
  State<FadeInAnimation> createState() =>
      _FadeInAnimationState();
}

class _FadeInAnimationState extends State<FadeInAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade, _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: Duration(milliseconds: widget.duration), vsync: this);
    _fade = Tween<double>(begin: widget.fadeStart, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _scale = Tween<double>(begin: widget.scaleStart, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    if(!_controller.isAnimating) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: FadeTransition(
        opacity: _fade,
        child: widget.child,
      ),
    );
  }
}
