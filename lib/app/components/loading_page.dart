import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Material(
          child: Container(
            color: Colors.teal,
            width: double.infinity,
            height: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 80,),
                AnimatedTextKit(
                  repeatForever: true,
                  animatedTexts: [
                    TyperAnimatedText('Updating...'),
                    TyperAnimatedText('Please wait a moment'),
                  ],),

              ],
            ),
          ),
        ),
      ],
    );
  }
}
