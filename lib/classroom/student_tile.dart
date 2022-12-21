import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pbs_app/classroom/student_dashboard.dart';

import '../app/components/avatar_image.dart';
import '../models/student.dart';
import '../utils/constants.dart';

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

  bool _isHighestPoints = false, _isPresent = false;
  int _points = 0;

  @override
  void initState() {
    _allStudentsStream = FirebaseFirestore.instance
        .collection(kCollectionClasses)
        .doc(widget.student.classRoom)
        .collection(kCollectionStudents)
        .snapshots();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        showDialog(
            barrierColor: Colors.transparent,
            context: context,
            builder: (context) => StudentDashboard(student: widget.student));
      },
      child: StreamBuilder(
          stream: _allStudentsStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              //   _isHighestPoints = checkIfHighestPoint(snapshot);
              // });

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
                    avatarKey:
                        '${widget.student.classRoom}_${widget.student.name}',
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
                            style: Theme.of(context).textTheme.displaySmall,
                            textAlign: TextAlign.right,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Expanded(child: SizedBox()),
                        Expanded(
                          flex: 7,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.black12,
                                  shape: BoxShape.circle),
                              child: Center(
                                child: Text(
                                  _points.toString(),
                                  style:
                                      Theme.of(context).textTheme.displaySmall,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ],
            );
          }),
    );
  }
}
