import 'package:flutter/material.dart';

import '../app/components/avatar_image.dart';
import '../models/student.dart';

class StudentTile extends StatelessWidget {
  const StudentTile({
    super.key,
    required this.student,
  });

  final Student student;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Column(
        children: [
          Expanded(
              child: AvatarImage(
                  avatarKey: '${student.classRoom}_${student.name}')),
          Expanded(child: Text(student.name)),
        ],
      ),
    );
  }
}
