import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pbs_app/home_page.dart';
import 'package:pbs_app/models/student.dart';
import 'package:pbs_app/configs/constants.dart';
import '../../app/components/loading_helper.dart';
import '../../classroom/class_room_main.dart';
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

Future<int> addClassroomsToFirebase({required List<String> classrooms}) async {
  try {
    for (var c in classrooms) {
      await FirebaseFirestore.instance
          .collection(kCollectionClassrooms)
          .doc(c)
          .set({});
    }
  } on FirebaseException catch (e) {
    developer.log(e.message!);
    return 400;
  }

  return 200;
}

Future<int> addStudentsToFirebase(
    {required List<Student> students, required WidgetRef ref}) async {
  try {
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
  } on FirebaseException catch (e) {
    developer.log(e.message!);
    return 400;
  }

  return 200;
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

void formSubmittedStudents(
    {required BuildContext context,
    required List<GlobalKey<FormBuilderState>> formKeys,
    required WidgetRef ref}) {
  final students = getStudentsFromForm(formKeys: formKeys);

  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (context) => LoadingHelper(
        future: addStudentsToFirebase(students: students, ref: ref),
        onFutureComplete: () {
          String message = 'Student added';
          if (formKeys.length > 1) {
            message = 'Student\'s added';
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
            ),
          );

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const ClassroomMain(),
            ),
          );
        },
      ),
    ),
  );
}

void formSubmittedClassrooms(
    {required BuildContext context,
    required List<GlobalKey<FormBuilderState>> formKeys,
    required WidgetRef ref}) {
  List<String> classrooms = [];
  for (var c in formKeys) {
    classrooms.add(c.currentState!.value.values.first);
  }

  String message = 'Classroom added';
  if(classrooms.length > 1){
    message = 'Classrooms added';
  }




  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (context) => LoadingHelper(
        future: addClassroomsToFirebase(classrooms: classrooms),
        onFutureComplete: () {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
              ),
            );
          });

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
        },
      ),
    ),
  );
}
