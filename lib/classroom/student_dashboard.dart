import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pbs_app/animations/slide_animation.dart';
import 'package:pbs_app/app/components/avatar_image.dart';
import 'package:pbs_app/app/components/loading_helper.dart';
import 'package:pbs_app/classroom/student_settings.dart';
import '../app/components/confirmation_box.dart';
import '../models/student.dart';
import '../utils/constants.dart';
import 'dart:math' as math;

import '../utils/methods/clear_points.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({Key? key, required this.student}) : super(key: key);

  final Student student;

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  late final FirebaseFirestore _firebaseInstance;
  late final DocumentReference _documentReference;
  late final Stream<DocumentSnapshot<Map<String, dynamic>>> _studentStream;

  bool _present = true;
  int _points = 0;

  @override
  void initState() {
    _firebaseInstance = FirebaseFirestore.instance;
    _documentReference = _firebaseInstance
        .collection(kCollectionClassrooms)
        .doc(widget.student.classRoom)
        .collection(kCollectionStudents)
        .doc(widget.student.name);

    _studentStream = _firebaseInstance
        .collection(kCollectionClassrooms)
        .doc(widget.student.classRoom)
        .collection(kCollectionStudents)
        .doc(widget.student.name)
        .snapshots();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SlideAnimation(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Material(
          color: Colors.teal,
          child: SizedBox(
            height: size.height * 0.20,
            width: size.width,
            child: Dialog(
              elevation: 0,
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.zero,
              child: StreamBuilder(
                  stream: _studentStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.hasData) {
                      _present = snapshot.data?.get('present');
                      _points = snapshot.data?.get('points');
                    }

                    return Column(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      width: size.width * 0.10,
                                      height: size.width * 0.10,
                                      child: AvatarImage(
                                        present: _present,
                                        student: widget.student,
                                      ),
                                    ),
                                    Text(widget.student.name),
                                    Text(widget.student.house),
                                    Text('$_points Points'),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          left: size.width * 0.05,
                                          right: size.width * 0.02,
                                        ),
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            await _firebaseInstance
                                                .collection(
                                                    kCollectionClassrooms)
                                                .doc(widget.student.classRoom)
                                                .collection(kCollectionStudents)
                                                .doc(widget.student.name)
                                                .update(
                                              {
                                                'points':
                                                    FieldValue.increment(1)
                                              },
                                            );
                                          },
                                          child: const Text('Award a Point!'),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          left: size.width * 0.02,
                                          right: size.width * 0.05,
                                        ),
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            _firebaseInstance.runTransaction(
                                              (transaction) async {
                                                transaction.update(
                                                  _documentReference,
                                                  {'present': !_present},
                                                );
                                              },
                                            );
                                          },
                                          child: Text(_present
                                              ? 'Mark Absent'
                                              : 'Mark Present'),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: IconButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                StudentSettings(
                                                    student: widget.student),
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: IconButton(
                                      onPressed: () async {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return Builder(
                                              builder: (context) {
                                                late final Future
                                                    clearPointsFuture =
                                                    clearPoints(
                                                        student:
                                                            widget.student);

                                                return ConfirmationBox(
                                                  title:
                                                      'Reset ${widget.student.name}\'s points?',
                                                  voidCallBack: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            LoadingHelper(
                                                                future:
                                                                    clearPointsFuture));
                                                  },
                                                );
                                              },
                                            );
                                          },
                                        );
                                      },
                                      icon: const Icon(Icons.refresh_outlined,
                                          color: Colors.white),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
            ),
          ),
        ),
      ),
    );
  }
}
