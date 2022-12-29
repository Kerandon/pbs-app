import 'package:flutter/material.dart';
import 'package:pbs_app/classroom/classroom_main.dart';

class ClassroomTile extends StatelessWidget {
  const ClassroomTile({
    super.key,
    required this.classroom,
  });

  final String classroom;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => ClassroomMain(classroom: classroom)));
      },
      child: Container(
        color: Colors.green,
        child: Text(classroom),
      ),
    );
  }
}
