import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pbs_app/classroom/class_room_main.dart';
import 'package:pbs_app/data/houses.dart';
import 'package:pbs_app/forms/custom_dropdown.dart';
import 'package:pbs_app/forms/custom_text_field.dart';
import 'package:pbs_app/models/student.dart';
import 'package:pbs_app/state/simple_providers.dart';
import 'package:pbs_app/utils/enums/gender.dart';
import 'package:pbs_app/utils/methods/generate_avatar.dart';

import '../app/components/avatar_image.dart';
import '../app/components/confirmation_box.dart';
import '../app/components/loading_helper.dart';
import '../forms/custom_number_field.dart';
import '../forms/student_settings_form.dart';
import '../utils/constants.dart';
import '../utils/methods/image_picker.dart';

class StudentSettings extends StatefulWidget {
  const StudentSettings({Key? key, required this.student}) : super(key: key);

  final Student student;

  @override
  State<StudentSettings> createState() => _StudentSettingsState();
}

class _StudentSettingsState extends State<StudentSettings> {
  late final Future<QuerySnapshot<Map<String, dynamic>>> _classesFuture;
  late final FirebaseFirestore _firebase;
  late final Stream<DocumentSnapshot> _studentStream;

  @override
  void initState() {
    _firebase = FirebaseFirestore.instance;
    _classesFuture = _firebase.collection(kCollectionClassrooms).get();
    _studentStream = _firebase
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
    return FutureBuilder(
      future: _classesFuture,
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        List<String> allClasses = [];
        if (snapshot.hasData) {
          for (var d in snapshot.data!.docs) {
            allClasses.add(d.id);
          }
        }

        return StreamBuilder(
          stream: _studentStream,
          builder: (context, snapshot) {
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ClassRoomMain(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.arrow_back_outlined),
                ),
                title: const Text('Edit Student Profile'),
              ),
              body: Padding(
                padding: EdgeInsets.fromLTRB(size.width * 0.10,
                    size.width * 0.02, size.width * 0.10, size.width * 0.02),
                child: ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Student avatar',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.80,
                      height: size.height * 0.15,
                      child: AvatarImage(
                        student: widget.student,
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.80,
                      height: size.height * 0.08,
                      child: Consumer(
                        builder: (_, ref, __) => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 10,
                              child: OutlinedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => ConfirmationBox(
                                      title: 'Generate New Robot Image?',
                                      voidCallBack: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => LoadingHelper(
                                              onFutureComplete: () {
                                                Navigator.of(context)
                                                    .pushAndRemoveUntil(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                StudentSettings(
                                                                    student: widget
                                                                        .student)),
                                                        (route) => false);
                                              },
                                              future: generateAvatar(
                                                  student: widget.student,
                                                  ref: ref),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: const Text('Regenerate'),
                              ),
                            ),
                            const Expanded(
                              child: SizedBox(),
                            ),
                            Expanded(
                              flex: 10,
                              child: OutlinedButton(
                                onPressed: () async {
                                  final result = await pickImage();
                                  if (result != null) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => LoadingHelper(
                                          onFutureComplete: () {
                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          StudentSettings(
                                                              student: widget
                                                                  .student),
                                                    ),
                                                    (route) => false);
                                          },
                                          future: saveFileImage(
                                              file: result,
                                              student: widget.student,
                                              ref: ref),
                                        ),
                                      ),
                                    );

                                    saveFileImage(
                                        file: result,
                                        student: widget.student,
                                        ref: ref);
                                  }
                                },
                                child: const Text('Pick Custom'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 16, bottom: 16),
                      child: Divider(),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Student details',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    StudentSettingsForm(student: widget.student),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
