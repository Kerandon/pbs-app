import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pbs_app/models/student.dart';
import 'package:pbs_app/utils/constants.dart';
import 'generate_avatar.dart';

List<Student> getStudentsFromForm(
    {required List<GlobalKey<FormBuilderState>> formKeys, String? classRoom}) {
  List<Student> students = [];

  for (var key in formKeys) {
    var value = key.currentState!.value;

    students.add(Student.fromForm(
      name: value[kName],
      gender: value[kGender],
      house: value[kHouse],
      classRoom: classRoom!,
    ));
  }

  return students;
}

Future<dynamic> addStudentsToFirebase(
    {required List<Student> students, required WidgetRef ref}) async {
  for (var s in students) {
    FirebaseFirestore.instance
        .collection(kCollectionClassrooms)
        .doc(s.classRoom)
        .collection(kCollectionStudents)
        .doc(s.name)
        .set(
      {
        kGender: s.gender.name,
        kHouse : s.house,
        kClassroom : s.classRoom,
        kPoints : 0,
        kPresent : true
      },
    );
    await generateAvatar(student: s, ref: ref);
  }

  return 1;
}
