import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pbs_app/app/components/avatar_image.dart';
import 'package:pbs_app/app/components/confirmation_box.dart';
import 'package:pbs_app/app/components/loading_helper.dart';
import 'package:pbs_app/app/components/loading_page.dart';
import 'package:pbs_app/classroom/classroom_main.dart';
import 'package:pbs_app/utils/app_messages.dart';
import 'package:pbs_app/utils/firebase_properties.dart';
import 'package:pbs_app/utils/methods/route_methods.dart';
import '../models/student.dart';
import '../utils/methods/methods_forms.dart';

class RemoveStudentsPage extends ConsumerStatefulWidget {
  const RemoveStudentsPage({Key? key, required this.classroom})
      : super(key: key);

  final String classroom;

  @override
  ConsumerState<RemoveStudentsPage> createState() => _RemoveStudentsPageState();
}

class _RemoveStudentsPageState extends ConsumerState<RemoveStudentsPage> {
  late final Stream<QuerySnapshot<Map<String, dynamic>>> _studentStream;

  final Map<Student, bool> _checkedList = {};
  Set<Student> students = {};
  bool _allSelected = false;
  int _numberSelected = 0;

  @override
  void initState() {
    _studentStream = FirebaseFirestore.instance
        .collection(FirebaseProperties.collectionClassrooms)
        .doc(widget.classroom)
        .collection(FirebaseProperties.collectionStudents)
        .snapshots();

    super.initState();
  }

  void _updateCheck({required Student student, required bool isChecked}) {
    _checkedList.addAll({student: isChecked});
    setState(() {});
  }

  void _selectAll() {
    if (!_allSelected) {
      for (var s in students) {
        _checkedList.addAll({s: true});
      }
    } else {
      for (var s in students) {
        _checkedList.addAll({s: false});
      }
    }

    _allSelected = !_allSelected;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _numberSelected = 0;
    for (var i in _checkedList.entries) {
      if (i.value) {
        _numberSelected++;
      }
    }

    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ClassroomMain(
                  classroom: widget.classroom,
                ),
              ),
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: size.width * 0.05),
            child: Center(
                child: Text(
              '${_numberSelected.toString()} selected',
              style: Theme.of(context).textTheme.headlineMedium,
            )),
          ),
          IconButton(
              onPressed: () {
                _selectAll();
              },
              icon: const Icon(Icons.select_all_outlined)),
        ],
      ),
      body: StreamBuilder(
        stream: _studentStream,
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData) {
            students = {};
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
                    child: SizedBox(
                      width: size.width,
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
                                                  ref: ref),
                                              onFutureComplete:
                                                  (taskResult) async {
                                                String scaffoldMessage = AppMessages
                                                    .kStudentSuccessfullyRemoved;

                                                if (_checkedList
                                                        .entries.length >
                                                    1) {
                                                  scaffoldMessage = AppMessages
                                                      .kStudentsSuccessfullyRemoved;
                                                }

                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content:
                                                        Text(scaffoldMessage),
                                                  ),
                                                );

                                                if (_checkedList.entries.every(
                                                    (element) =>
                                                        element.value)) {
                                                  await pushReplacementRoute(
                                                    context,
                                                    ClassroomMain(
                                                        classroom:
                                                            widget.classroom),
                                                  );
                                                } else {
                                                  await pushReplacementRoute(
                                                    context,
                                                    RemoveStudentsPage(
                                                        classroom:
                                                            widget.classroom),
                                                  );
                                                }
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
