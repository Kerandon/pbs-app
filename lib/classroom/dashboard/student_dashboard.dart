import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pbs_app/animations/slide_animation.dart';
import 'package:pbs_app/app/components/avatar_image.dart';
import 'package:pbs_app/app/components/loading_helper.dart';
import 'package:pbs_app/classroom/dashboard/awards_menu.dart';
import 'package:pbs_app/classroom/dashboard/points_button.dart';
import 'package:pbs_app/classroom/student_settings.dart';
import 'package:pbs_app/utils/firebase_properties.dart';
import '../../app/components/confirmation_box.dart';
import '../../configs/ui_constants.dart';
import '../../models/student.dart';

import '../../utils/methods/points_methods.dart';
import '../../utils/methods/route_methods.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({Key? key, required this.student}) : super(key: key);

  final Student student;

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  late final DocumentReference<Map<String, dynamic>> _documentReference;
  late final Stream<DocumentSnapshot<Map<String, dynamic>>> _studentStream;

  bool _present = true;
  int _points = 0;

  @override
  void initState() {
    _documentReference = FirebaseFirestore.instance
        .collection(FirebaseProperties.collectionClassrooms)
        .doc(widget.student.classroom)
        .collection(FirebaseProperties.collectionStudents)
        .doc(widget.student.name);

    _studentStream = _documentReference.snapshots();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SlideAnimation(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          height: size.height * 0.50,
          width: size.width,
          child: Column(
            children: [
              Expanded(
                  flex: 2,
                  child: PointsButton(
                    documentRef: _documentReference,
                  ),),
              Expanded(
                flex: 2,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(kBorderRadius),
                      topRight: Radius.circular(kBorderRadius)),
                  child: Material(
                    color: Colors.deepPurple,
                    child: Dialog(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      insetPadding: EdgeInsets.zero,
                      child: StreamBuilder(
                          stream: _studentStream,
                          builder: (BuildContext context,
                              AsyncSnapshot<
                                      DocumentSnapshot<Map<String, dynamic>>>
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
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
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                             AwardsMenu(student: widget.student,));
                                                  },
                                                  child: const Text(
                                                      'More Awards...'),
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
                                                    FirebaseFirestore.instance
                                                        .runTransaction(
                                                      (transaction) async {
                                                        transaction.update(
                                                          _documentReference,
                                                          {
                                                            'present': !_present
                                                          },
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
                                      Padding(
                                        padding: const EdgeInsets.only(top: 6),
                                        child: Container(
                                          color: Colors.black12,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: IconButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pushReplacement(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            StudentSettings(
                                                                student: widget
                                                                    .student),
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
                                                  onPressed: _points > 0
                                                      ? () async {
                                                          showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return Builder(
                                                                builder:
                                                                    (context) {
                                                                  return ConfirmationBox(
                                                                    title:
                                                                        'Clear ${widget.student.name}\'s points?',
                                                                    voidCallBack:
                                                                        () {
                                                                      pushRoute(
                                                                        context,
                                                                        LoadingHelper(
                                                                            text1:
                                                                                "Clearing points",
                                                                            future:
                                                                                clearPoints(student: widget.student)),
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                              );
                                                            },
                                                          );
                                                        }
                                                      : null,
                                                  icon: const Icon(
                                                      Icons.refresh_outlined,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
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
            ],
          ),
        ),
      ),
    );
  }
}
