import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pbs_app/app/components/loading_page.dart';
import 'package:pbs_app/app/components/sub_banner.dart';
import 'package:pbs_app/classroom/student_tile.dart';
import 'package:pbs_app/utils/app_messages.dart';
import 'package:pbs_app/utils/firebase_properties.dart';
import 'package:pbs_app/home_page.dart';
import '../app/components/error_page.dart';
import '../models/student.dart';
import '../utils/methods/points_methods.dart';
import 'classroom_drawer.dart';

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
    final size = MediaQuery
        .of(context)
        .size;

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

            int totalStudents = students.length;
            int totalPresent = 0;
            int totalPoints = 0;


            if (docs != null) {
              students = docs
                  .map((e) => Student.fromJson(name: e.id, json: e.data()))
                  .toSet();


              for(var s in students){
                if(s.present){
                  totalPresent++;
                }
                int points = s.points;
                totalPoints += points;
              }
            }

            setTopPointsScorers(students: students);


            return Stack(
              children: [
                Column(
                  children: [
                    SubBanner(contents: [
                      const Icon(Icons.person),
                      SizedBox(
                        width: size.width * 0.01,
                      ),
                      Text('$totalPresent / $totalStudents'),
                      SizedBox(width: size.width * 0.30,),

                      const Icon(Icons.celebration_outlined),
                      SizedBox(
                        width: size.width * 0.01,
                      ),
                      Text(totalPoints.toString()),

                ],),
                    //ClassroomStatsBar(students: students,),
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
                            mainAxisSpacing: size.width * 0.01,
                            crossAxisSpacing: size.width * 0.01,
                            mainAxisExtent: size.height * 0.12
                        ),
                        itemBuilder: (context, index) {
                          return StudentTile(
                            student: students.elementAt(index),
                          );
                        },
                      )
                          : Padding(
                        padding: EdgeInsets.all(size.width * 0.01),
                        child: const Center(
                          child: Text(
                            AppMessages.addStudents,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
        },
      ),
      endDrawer: ClassroomDrawer(
          classroom: widget.classroom, students: students),
    );
  }
}