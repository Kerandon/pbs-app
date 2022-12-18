import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pbs_app/models/student.dart';
import 'package:pbs_app/utils/constants.dart';

import 'methods_avatar_images.dart';

List<Student> getStudentsFromForm(
    {required List<GlobalKey<FormBuilderState>> formKeys, String? classRoom}) {
  List<Student> students = [];

  for (var key in formKeys) {
    var value = key.currentState!.value;

    students.add(Student.fromForm(
        name: value['name'],
        gender: value['gender'],
        house: value['house'],
        classRoom: classRoom!));
  }

  return students;
}

Future<dynamic> addStudentsToFirebase(
    {required List<Student> students, required WidgetRef ref}) async {
  for (var s in students) {
    FirebaseFirestore.instance
        .collection(kCollectionClasses)
        .doc(s.classRoom)
        .collection(kCollectionStudents)
        .doc(s.name)
        .set(
      {'gender': s.gender.name, 'house': s.house, 'classroom': s.classRoom},
    );
    await generateAvatar(student: s, ref: ref);
  }

  return 1;
}
