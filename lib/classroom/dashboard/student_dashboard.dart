import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pbs_app/animations/slide_animation.dart';
import 'package:pbs_app/app/components/avatar_image.dart';
import 'package:pbs_app/app/components/loading_helper.dart';
import 'package:pbs_app/classroom/dashboard/awards_menu.dart';
import 'package:pbs_app/classroom/dashboard/students_awards_banner.dart';
import 'package:pbs_app/classroom/notes/notes_main.dart';
import 'package:pbs_app/classroom/student_settings.dart';
import 'package:pbs_app/utils/enums/gender.dart';
import 'package:pbs_app/utils/firebase_properties.dart';
import '../../app/components/confirmation_box.dart';
import '../../app/components/flair_box.dart';
import '../../app/components/loading_page.dart';
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
          height: size.height * 0.30,
          width: size.width,
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(kBorderRadius),
                      topRight: Radius.circular(kBorderRadius)),
                  child: Material(
                    color: Theme.of(context).primaryColor,
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
                            Student student = Student.emptyInitialize();
                            if (snapshot.hasData && snapshot.data != null) {
                              student = Student.fromJson(
                                  name: snapshot.data!.id,
                                  json: snapshot.data!.data()!);

                              return Column(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: size.height * 0.008),
                                      child: StudentsAwardsBanner(
                                        student: student,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 5,
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
                                                width: size.width * 0.25,
                                                height: size.width * 0.18,
                                                child: AvatarImage(
                                                  present: student.present,
                                                  student: student,
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              student.name,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .displaySmall!
                                                                  .copyWith(
                                                                      color: Colors
                                                                          .white),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              student.gender
                                                                  .toText(),
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .displaySmall!
                                                                  .copyWith(
                                                                      color: Colors
                                                                          .white),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              student.classroom,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .displaySmall!
                                                                  .copyWith(
                                                                      color: Colors
                                                                          .white),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              student.house,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .displaySmall!
                                                                  .copyWith(
                                                                      color: Colors
                                                                          .white),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          FlairBox(
                                                            iconData: Icons
                                                                .celebration_outlined,
                                                            text:
                                                                '${student.points} Points',
                                                            onPressed:
                                                                () async {
                                                              await awardStudentOnePoint(
                                                                  documentRef:
                                                                      _documentReference);
                                                            },
                                                          ),
                                                          SizedBox(
                                                              width:
                                                                  size.width *
                                                                      0.02),
                                                          FlairBox(
                                                            iconData:
                                                                FontAwesomeIcons
                                                                    .trophy,
                                                            text: '21 Awards',
                                                            onPressed: () {
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) =>
                                                                        AwardsMenu(
                                                                  student:
                                                                      student,
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: size.height * 0.01,
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(
                                              size.width * 0.10,
                                              size.height * 0.02,
                                              size.width * 0.10,
                                              size.height * 0.02,
                                            ),
                                            child: SizedBox(
                                              width: size.width,
                                              child: OutlinedButton(
                                                style: OutlinedButton.styleFrom(
                                                    foregroundColor:
                                                        Colors.white),
                                                onPressed: () async {
                                                  FirebaseFirestore.instance
                                                      .runTransaction(
                                                    (transaction) async {
                                                      transaction.update(
                                                        _documentReference,
                                                        {
                                                          'present':
                                                              !student.present,
                                                        },
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      student.present
                                                          ? FontAwesomeIcons
                                                              .house
                                                          : FontAwesomeIcons
                                                              .graduationCap,
                                                      size: 15,
                                                    ),
                                                    SizedBox(
                                                      width: size.width * 0.10,
                                                    ),
                                                    Text(student.present
                                                        ? 'Mark Absent'
                                                        : 'Mark Present'),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 6),
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
                                                                  student:
                                                                      student),
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
                                                    onPressed: () {
                                                      pushReplacementRoute(
                                                        context,
                                                        NotesMain(
                                                          student: student,
                                                        ),
                                                      );
                                                    },
                                                    icon: const FaIcon(
                                                      FontAwesomeIcons
                                                          .noteSticky,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: IconButton(
                                                    onPressed:
                                                        student.points > 0
                                                            ? () async {
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return Builder(
                                                                      builder:
                                                                          (context) {
                                                                        return ConfirmationBox(
                                                                          title:
                                                                              'Clear ${student.name}\'s points?',
                                                                          voidCallBack:
                                                                              () {
                                                                            pushRoute(
                                                                              context,
                                                                              LoadingHelper(text1: "Clearing points", future: clearPoints(student: student)),
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
                            }
                            return const LoadingPage();
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
