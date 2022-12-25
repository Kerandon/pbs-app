import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pbs_app/app/components/loading_page.dart';
import 'package:pbs_app/classroom/student_tile.dart';
import 'package:pbs_app/utils/enums/form_types.dart';
import 'package:pbs_app/utils/constants.dart';
import 'package:pbs_app/utils/methods/methods_forms.dart';
import '../app/components/error_page.dart';
import '../forms/form_main.dart';
import '../app/components/loading_helper.dart';
import '../models/student.dart';

class ClassRoomMain extends ConsumerStatefulWidget {
  const ClassRoomMain({Key? key}) : super(key: key);

  @override
  ConsumerState<ClassRoomMain> createState() => _ClassRoomMainState();
}

class _ClassRoomMainState extends ConsumerState<ClassRoomMain> {
  late final Stream<QuerySnapshot<Map<String, dynamic>>> _classRoomStream;

  @override
  void initState() {
    _classRoomStream = FirebaseFirestore.instance
        .collection(kCollectionClassrooms)
        .doc('B1')
        .collection(kCollectionStudents)
        .snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return StreamBuilder(
      stream: _classRoomStream,
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasError) {
          return const ErrorPage();
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingPage();
        } else {
          List<Student> students = [];

          final docs = snapshot.data?.docs;

          if (docs != null) {
            students = docs
                .map((e) => Student.fromJson(name: e.id, json: e.data()))
                .toList();
          }

          return Stack(
            children: [
              Scaffold(
                appBar: AppBar(),
                body: students.isNotEmpty
                    ? GridView.builder(
                        itemCount: students.length,
                        padding: EdgeInsets.only(
                            left: size.width * 0.08,
                            top: size.height * 0.02,
                            right: size.width * 0.08),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          mainAxisSpacing: size.width * 0.02,
                          crossAxisSpacing: size.width * 0.02,
                        ),
                        itemBuilder: (context, index) {
                          return StudentTile(
                            student: students[index],
                          );
                        },
                      )
                    : const Center(
                        child: Text(
                            'Add students to your class (top right menu)')),
                drawer: Drawer(
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.10,
                      ),
                      ListTile(
                        leading: const Icon(Icons.add),
                        title: const Text('Add Students'),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => FormMain(
                                formType: FormType.student,
                                onSubmit: (formKeys) async {
                                  final students = getStudentsFromForm(
                                      formKeys: formKeys, classRoom: 'B1');
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => LoadingHelper(
                                        future: addStudentsToFirebase(
                                            students: students, ref: ref),
                                        onFutureComplete: () async {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Students added successfully!'),
                                            ),
                                          );
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const ClassRoomMain(),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
