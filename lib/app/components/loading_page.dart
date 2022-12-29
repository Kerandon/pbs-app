import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key, this.text1, this.text2}) : super(key: key);

  final String? text1, text2;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Material(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(
                  height: 80,
                ),
                AnimatedTextKit(
                  repeatForever: true,
                  animatedTexts: [
                    TyperAnimatedText(text1 ?? "Updating"),
                    TyperAnimatedText(text2 ?? "Just a moment"),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
