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
    return Material(
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => ClassroomMain(classroom: classroom)));
        },
        child: Column(
          children: [
            Expanded(
                flex: 2,
                child: Icon(Icons.school_outlined),),
            Expanded(child: Text(classroom),),
          ],
        ),
      ),
    );
  }
}
