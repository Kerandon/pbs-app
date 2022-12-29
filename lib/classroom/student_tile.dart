import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pbs_app/classroom/student_dashboard.dart';
import 'package:pbs_app/utils/firebase_properties.dart';

import '../app/components/avatar_image.dart';
import '../models/student.dart';

class StudentTile extends StatefulWidget {
  const StudentTile({
    super.key,
    required this.student,
  });

  final Student student;

  @override
  State<StudentTile> createState() => _StudentTileState();
}

class _StudentTileState extends State<StudentTile> {
  late final Stream<QuerySnapshot<Map<String, dynamic>>> _allStudentsStream;

  bool _isPresent = false;
  int _points = 0;

  @override
  void initState() {
    _allStudentsStream = FirebaseFirestore.instance
        .collection(FirebaseProperties.collectionClassrooms)
        .doc(widget.student.classroom)
        .collection(FirebaseProperties.collectionStudents)
        .snapshots();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        InkWell(
          onTap: () {
            showDialog(
                barrierColor: Colors.transparent,
                context: context,
                builder: (context) =>
                    StudentDashboard(student: widget.student));
          },
          child: StreamBuilder(
            stream: _allStudentsStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final docs = snapshot.data!.docs;
                for (var d in docs) {
                  if (d.id == widget.student.name) {
                    _points = d.get('points');
                    _isPresent = d.get('present');
                  }
                }
              }
              return Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: AvatarImage(
                      student: widget.student,
                      present: _isPresent,
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.005,
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 10,
                          child: Text(
                            widget.student.name,
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall
                                ?.copyWith(fontSize: 12),
                            textAlign: TextAlign.right,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                        Expanded(
                          flex: 5,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: Colors.black12,
                                  shape: BoxShape.circle),
                              child: Center(
                                child: Text(
                                  _points.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall
                                      ?.copyWith(fontSize: 12),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
