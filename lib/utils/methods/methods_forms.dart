import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pbs_app/models/student.dart';
import 'package:pbs_app/configs/constants.dart';
import 'avatar_methods.dart';
import 'dart:typed_data';
import '../../state/simple_providers.dart';
import 'dart:developer' as developer;

List<Student> getStudentsFromForm(
    {required List<GlobalKey<FormBuilderState>> formKeys, String? classRoom}) {
  List<Student> students = [];

  for (var key in formKeys) {
    var value = key.currentState!.value;

    students.add(Student.fromForm(
      name: value[kName],
      gender: 'Male',
      house: value[kHouse],
      classRoom: 'B1',
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
        kHouse: s.house,
        kClassroom: s.classRoom,
        kPoints: 0,
        kAttendance: true
      },
    );
    await generateAvatar(student: s, ref: ref);
  }

  return 1;
}

Future<int?> updateStudentDetails(
    {required Student student,
    required GlobalKey<FormBuilderState> formKey,
    required WidgetRef ref}) async {
  final documentReference = FirebaseFirestore.instance
      .collection(kCollectionClassrooms)
      .doc('B1')
      .collection(kCollectionStudents)
      .doc(student.name);

  final value = formKey.currentState!.value;
  Uint8List bytes;
  String formName = value[kName];
  if (student.name != formName) {
    String avatarKeyCurrent = '${student.classRoom}_${student.name}';

    bytes = ref
        .read(avatarProvider)
        .firstWhere((element) => element.avatarKey == avatarKeyCurrent)
        .bytes;

    try {
      await FirebaseFirestore.instance
          .collection(kCollectionClassrooms)
          .doc('B1')
          .collection(kCollectionStudents)
          .doc(formName)
          .set({
        kGender: value[kGender],
        kClassroom: 'B1',
        kHouse: value[kHouse],
        kPoints: int.parse(value[kPoints]),
        kAttendance: value[kAttendance] == 'Present' ? true : false
      }).then((value) async {
        await documentReference.delete();
      });
    } on FirebaseException catch (e) {
      developer.log(e.message!);
      return null;
    }

    String avatarKeyNew = 'B1_$formName';
    await saveImageData(bytes: bytes, avatarKey: avatarKeyNew, ref: ref);
  } else {
    try {
      await documentReference.set({
        'gender': value[kGender],
        'classroom': 'B1',
        'house': value[kHouse],
        'points': int.parse(value[kPoints]),
        'present': value[kAttendance] == 'Present' ? true : false
      });
    } on FirebaseException catch (e) {
      developer.log(e.message!);
      return null;
    }
  }

  return 200;
}

Future<int> deleteStudents({required Set<Student> students}) async {
  final studentCollection = FirebaseFirestore.instance
      .collection(kCollectionClassrooms)
      .doc('B1')
      .collection(kCollectionStudents);

  try {
    for (var s in students) {
      await studentCollection.doc(s.name).delete();
    }
  } on FirebaseException catch (e) {
    developer.log(e.message!);
    return 400;
  }
  return 200;
}
