import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pbs_app/app/components/avatar_image.dart';
import 'package:pbs_app/app/components/confirmation_box.dart';
import 'package:pbs_app/app/components/loading_helper.dart';
import 'package:pbs_app/app/components/loading_page.dart';
import 'package:pbs_app/classroom/classroom_main.dart';
import 'package:pbs_app/configs/constants.dart';

import '../models/student.dart';
import '../utils/methods/methods_forms.dart';

class RemoveStudentsPage extends StatefulWidget {
  const RemoveStudentsPage({Key? key}) : super(key: key);

  @override
  State<RemoveStudentsPage> createState() => _RemoveStudentsPageState();
}

class _RemoveStudentsPageState extends State<RemoveStudentsPage> {
  late final Stream<QuerySnapshot<Map<String, dynamic>>> _studentStream;

  final Map<Student, bool> _checkedList = {};

  @override
  void initState() {
    _studentStream = FirebaseFirestore.instance
        .collection(kCollectionClassrooms)
        .doc('B1')
        .collection(kCollectionStudents)
        .snapshots();

    super.initState();
  }

  void _updateCheck({required Student student, required bool isChecked}) {
    _checkedList.addAll({student: isChecked});
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ClassroomMain()));

        }, icon: Icon(Icons.arrow_back)),
      ),
      body: StreamBuilder(
        stream: _studentStream,
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData) {
            Set<Student> students = {};
            final docs = snapshot.data!.docs;

            for (var s in docs) {
              students.add(Student.fromJson(name: s.id, json: s.data()));
            }

            return ListView.builder(
              itemCount: students.length + 1,
              itemBuilder: (context, index) {
                if (index < students.length) {
                  return CheckboxListTile(
                      title: Row(
                        children: [
                          SizedBox(
                            width: size.width * 0.10,
                            height: size.height * 0.10,
                            child: AvatarImage(
                              student: students.elementAt(index),
                            ),
                          ),
                          SizedBox(
                            width: size.width * 0.03,
                          ),
                          Text(students.elementAt(index).name),
                        ],
                      ),
                      value: _checkedList.containsKey(students.elementAt(index))
                          ? _checkedList.entries
                              .firstWhere((element) =>
                                  element.key.name ==
                                  students.elementAt(index).name)
                              .value
                          : false,
                      onChanged: (value) {
                        _updateCheck(
                            student: students.elementAt(index),
                            isChecked: value!);
                      });
                }
                if (index == students.length) {
                  return Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: Center(
                      child: OutlinedButton(
                          onPressed: _checkedList.entries
                                  .any((element) => element.value == true)
                              ? () {
                                  Set<Student> studentsToDelete = {};

                                  for (var e in _checkedList.entries) {
                                    if (e.value) {
                                      studentsToDelete.add(e.key);
                                    }
                                  }

                                  String message =
                                      'Remove the ${studentsToDelete.length} selected student?';
                                  if (studentsToDelete.length > 1) {
                                    message =
                                        'Remove the ${studentsToDelete.length} selected students?';
                                  }

                                  showDialog(
                                    context: context,
                                    builder: (context) => ConfirmationBox(
                                      title: message,
                                      voidCallBack: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => LoadingHelper(
                                              future: deleteStudents(
                                                students: studentsToDelete,
                                              ),
                                              onFutureComplete: () {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(const SnackBar(
                                                        content: Text(
                                                            'Students removed'),),);

                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const RemoveStudentsPage(),),);
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                }
                              : null,
                          child: const Text('Remove')),
                    ),
                  );
                }
                return null;
              },
            );
          }
          return const LoadingPage();
        },
      ),
    );
  }
}
