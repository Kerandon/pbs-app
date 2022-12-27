import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../classroom/student_crown.dart';
import '../../models/student.dart';
import '../../configs/constants.dart';

class CrownWidget extends StatefulWidget {
  const CrownWidget({Key? key, required this.student}) : super(key: key);

  final Student student;

  @override
  State<CrownWidget> createState() => _CrownWidgetState();
}

class _CrownWidgetState extends State<CrownWidget> {
  late final Stream<QuerySnapshot<Map<String, dynamic>>> _allStudentsStream;
  bool _showCrown = false;

  @override
  void initState() {
    _allStudentsStream = FirebaseFirestore.instance
        .collection(kCollectionClassrooms)
        .doc(widget.student.classRoom)
        .collection(kCollectionStudents)
        .snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _allStudentsStream,
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        List<Student> students = [];

        if (snapshot.hasData) {
          final docs = snapshot.data!.docs;
          for (var d in docs) {
            students.add(
              Student.fromJson(
                name: d.id,
                json: d.data(),
              ),
            );
          }
        }

        students.sort((a, b) => b.points.compareTo(a.points));
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          if (students.isNotEmpty) {
            if (widget.student.points == students.first.points || widget.student.name == students.first.name) {
              _showCrown = true;
            } else {
              _showCrown = false;
            }
            if(widget.student.points == 0){
              _showCrown = false;
            }
          }
          if(mounted) {
            setState(() {});
          }

        });

        return _showCrown ? const StudentCrown() : const SizedBox();
      },
    );
  }
}