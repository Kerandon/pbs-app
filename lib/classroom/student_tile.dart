import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pbs_app/classroom/dashboard/student_dashboard.dart';
import 'package:pbs_app/configs/ui_constants.dart';
import 'package:pbs_app/utils/firebase_properties.dart';
import '../app/components/avatar_image.dart';
import '../configs/app_colors.dart';
import '../models/student.dart';
import 'dashboard/students_awards_banner.dart';

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
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _allStudentsStream,
      builder: (context, snapshot) {
        Student student = Student.emptyInitialize();

        if (snapshot.hasData) {
          final docs = snapshot.data!.docs;
          for (var d in docs) {
            if (d.id == widget.student.name) {
              student = Student.fromJson(name: d.id, json: d.data());
            }
          }
        }

        return InkWell(
          onTap: () {
            showDialog(
                barrierColor: Colors.transparent,
                context: context,
                builder: (context) =>
                    StudentDashboard(student: widget.student));
          },
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: AvatarImage(
                  student: widget.student,
                  present: student.present,
                ),
              ),
              SizedBox(
                height: size.height * 0.005,
              ),
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        widget.student.name,
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall
                            ?.copyWith(fontSize: 10, color: Colors.black),
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    student.topPoints
                        ? const Icon(
                            FontAwesomeIcons.award,
                            color: AppColors.quinceJelly,
                            size: 16,
                          )
                        : SizedBox(
                            width: size.width * 0.02,
                          ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        decoration: BoxDecoration(
                          color: student.topPoints
                              ? AppColors.quinceJelly
                              : AppColors.hintOfIce,
                          borderRadius: BorderRadius.circular(kBorderRadius),
                        ),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                              size.width * 0.01,
                              size.width * 0.01,
                              size.width * 0.01,
                              size.width * 0.01),
                          child: Text(
                            student.points.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(fontSize: 10, color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
