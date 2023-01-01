import 'package:flutter/material.dart';

class StudentCrown extends StatelessWidget {
  const StudentCrown({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const Alignment(0.10, -1.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final biggest = constraints.biggest;
          return Transform.rotate(
            angle: -50,
            child: Container(
              width: biggest.width * 0.30,
              height: biggest.height * 0.30,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/crown.png'),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
