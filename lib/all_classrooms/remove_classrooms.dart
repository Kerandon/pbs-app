import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pbs_app/app/components/confirmation_box.dart';
import 'package:pbs_app/app/components/loading_helper.dart';
import 'package:pbs_app/app/components/loading_page.dart';
import 'package:pbs_app/utils/firebase_properties.dart';
import 'package:pbs_app/home_page.dart';
import '../utils/methods/methods_forms.dart';

class RemoveClassrooms extends StatefulWidget {
  const RemoveClassrooms({Key? key}) : super(key: key);

  @override
  State<RemoveClassrooms> createState() => _RemoveClassroomsState();
}

class _RemoveClassroomsState extends State<RemoveClassrooms> {
  late final Stream<QuerySnapshot<Map<String, dynamic>>> _classroomStream;

  final Map<String, bool> _checkedList = {};

  @override
  void initState() {
    _classroomStream = FirebaseFirestore.instance
        .collection(FirebaseProperties.collectionClassrooms)
        .snapshots();

    super.initState();
  }

  void _updateCheck({required String classroom, required bool isChecked}) {
    _checkedList.addAll({classroom: isChecked});
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const HomePage()));
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: StreamBuilder(
        stream: _classroomStream,
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData) {
            Set<String> classrooms = {};
            final docs = snapshot.data!.docs;

            for (var s in docs) {
              classrooms.add(s.id);
            }

            return ListView.builder(
              itemCount: classrooms.length + 1,
              itemBuilder: (context, index) {
                if (index < classrooms.length) {
                  return CheckboxListTile(
                      title: Row(
                        children: [
                          Text(classrooms.elementAt(index)),
                        ],
                      ),
                      value: _checkedList
                              .containsKey(classrooms.elementAt(index))
                          ? _checkedList.entries
                              .firstWhere((element) =>
                                  element.key == classrooms.elementAt(index))
                              .value
                          : false,
                      onChanged: (value) {
                        _updateCheck(
                            classroom: classrooms.elementAt(index),
                            isChecked: value!);
                      });
                }
                if (index == classrooms.length) {
                  return Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: SizedBox(
                      width: size.width,
                      child: OutlinedButton(
                          onPressed: _checkedList.entries
                                  .any((element) => element.value == true)
                              ? () {
                                  Set<String> classroomsToDelete = {};

                                  for (var e in _checkedList.entries) {
                                    if (e.value) {
                                      classroomsToDelete.add(e.key);
                                    }
                                  }

                                  String message =
                                      'Remove the ${classroomsToDelete.length} selected classroom?';
                                  if (classroomsToDelete.length > 1) {
                                    message =
                                        'Remove the ${classroomsToDelete.length} selected classrooms?';
                                  }

                                  showDialog(
                                    context: context,
                                    builder: (context) => ConfirmationBox(
                                      title: message,
                                      voidCallBack: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => LoadingHelper(
                                              future: deleteClassrooms(
                                                classrooms: classrooms,
                                              ),
                                              onFutureComplete: (error) {
                                                String message =
                                                    'Classroom removed';
                                                if (classrooms.length > 1) {
                                                  message =
                                                      'Classrooms removed';
                                                }

                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(message),
                                                  ),
                                                );

                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const RemoveClassrooms(),
                                                  ),
                                                );
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
