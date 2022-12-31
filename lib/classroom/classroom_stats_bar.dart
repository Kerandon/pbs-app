
import 'package:flutter/material.dart';

import '../models/student.dart';

class ClassroomStatsBar extends StatelessWidget {
  const ClassroomStatsBar({
    super.key, required this.students,
  });

  final Set<Student> students;

  @override
  Widget build(BuildContext context) {

    int totalStudents = students.length;
    int totalPresent = 0;
    int totalPoints = 0;
    for(var s in students){
      if(s.present){
        totalPresent++;
      }
      int points = s.points;
      totalPoints += points;
    }

    final size = MediaQuery.of(context).size;
    return Container(
      color: Colors.orange,
      height: size.height * 0.04,
      child: Row(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person),
                SizedBox(
                  width: size.width * 0.01,
                ),
                Text('$totalPresent / $totalStudents'),
              ],
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.celebration_outlined),
                SizedBox(
                  width: size.width * 0.01,
                ),
                Text(totalPoints.toString()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
