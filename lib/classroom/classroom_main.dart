import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pbs_app/app/components/loading_page.dart';
import 'package:pbs_app/classroom/student_tile.dart';
import 'package:pbs_app/utils/app_messages.dart';
import 'package:pbs_app/utils/firebase_properties.dart';
import 'package:pbs_app/home_page.dart';
import '../app/components/error_page.dart';
import '../models/student.dart';
import 'classroom_drawer.dart';
import 'classroom_stats_bar.dart';

class ClassroomMain extends ConsumerStatefulWidget {
  const ClassroomMain({required this.classroom, Key? key}) : super(key: key);

  final String classroom;

  @override
  ConsumerState<ClassroomMain> createState() => _ClassRoomMainState();
}

class _ClassRoomMainState extends ConsumerState<ClassroomMain> {
  late final Stream<QuerySnapshot<Map<String, dynamic>>> _classRoomStream;
  Set<Student> students = {};

  @override
  void initState() {
    _classRoomStream = FirebaseFirestore.instance
        .collection(FirebaseProperties.collectionClassrooms)
        .doc(widget.classroom)
        .collection(FirebaseProperties.collectionStudents)
        .snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const HomePage()));
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          widget.classroom,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _classRoomStream,
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasError) {
            return const ErrorPage();
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingPage();
          } else {
            students.clear();

            final docs = snapshot.data?.docs;

            if (docs != null) {
              students = docs
                  .map((e) => Student.fromJson(name: e.id, json: e.data()))
                 .toSet();
            }

            return Column(
              children: [
                ClassroomStatsBar(students: students,),
                Expanded(
                  flex: 5,
                  child: students.isNotEmpty
                      ? GridView.builder(
                          itemCount: students.length,
                          padding: EdgeInsets.only(
                              left: size.width * 0.08,
                              top: size.height * 0.02,
                              right: size.width * 0.08),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            mainAxisSpacing: size.width * 0.02,
                            crossAxisSpacing: size.width * 0.02,
                          ),
                          itemBuilder: (context, index) {
                            return StudentTile(
                              student: students.elementAt(index),
                            );
                          },
                        )
                      : const Padding(
                          padding: EdgeInsets.all(38.0),
                          child: Center(
                            child: Text(
                              AppMessages.getStartedByAddingStudents,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                ),
              ],
            );
          }
        },
      ),
      endDrawer: ClassroomDrawer(classroom: widget.classroom, students: students),
    );
  }
}
