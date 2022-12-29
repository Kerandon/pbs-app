import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pbs_app/home_page.dart';
import 'package:pbs_app/models/student.dart';
import '../../app/components/loading_helper.dart';
import '../../classroom/classroom_main.dart';
import '../firebase_properties.dart';
import '../enums/task_status.dart';
import 'avatar_methods.dart';
import 'dart:typed_data';
import '../../state/simple_providers.dart';
import 'dart:developer' as developer;

List<Student> getStudentsFromForm(
    {required List<GlobalKey<FormBuilderState>> formKeys}) {
  List<Student> students = [];

  for (var key in formKeys) {
    var value = key.currentState!.value;

    students.add(Student.fromForm(
      name: value[FirebaseProperties.name],
      gender: value[FirebaseProperties.gender],
      house: value[FirebaseProperties.house],
      classRoom: value[FirebaseProperties.classroom],
    ));
  }

  return students;
}

Future<int> addClassroomsToFirebase({required List<String> classrooms}) async {
  try {
    for (var c in classrooms) {
      await FirebaseFirestore.instance
          .collection(FirebaseProperties.collectionClassrooms)
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
          .collection(FirebaseProperties.collectionClassrooms)
          .doc(s.classroom)
          .collection(FirebaseProperties.collectionStudents)
          .doc(s.name)
          .set(
        {
          FirebaseProperties.gender: s.gender.name,
          FirebaseProperties.house: s.house,
          FirebaseProperties.classroom: s.classroom,
          FirebaseProperties.points: 0,
          FirebaseProperties.attendance: true
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

Future<TaskStatus> updateStudentDetails(
    {required Student student,
    required GlobalKey<FormBuilderState> formKey,
    required WidgetRef ref}) async {
  final exists = await checkIfStudentExistsInClassroom(formKey: formKey);

  if (exists) {
    return TaskStatus.failStudentAlreadyExists;
  } else {
    final documentReference = FirebaseFirestore.instance
        .collection(FirebaseProperties.collectionClassrooms)
        .doc(student.classroom)
        .collection(FirebaseProperties.collectionStudents)
        .doc(student.name);

    final value = formKey.currentState!.value;
    Uint8List bytes;
    String formName = value[FirebaseProperties.name];
    String formClassroom = value[FirebaseProperties.classroom];

    if (student.name != formName || student.classroom != formClassroom) {
      String avatarKeyCurrent = '${student.classroom}_${student.name}';

      bytes = ref
          .read(avatarProvider)
          .firstWhere((element) => element.avatarKey == avatarKeyCurrent)
          .bytes;

      try {
        await FirebaseFirestore.instance
            .collection(FirebaseProperties.collectionClassrooms)
            .doc(formClassroom)
            .collection(FirebaseProperties.collectionStudents)
            .doc(formName)
            .set({
          FirebaseProperties.gender: value[FirebaseProperties.gender],
          FirebaseProperties.classroom: formClassroom,
          FirebaseProperties.house: value[FirebaseProperties.house],
          FirebaseProperties.points:
              int.parse(value[FirebaseProperties.points]),
          FirebaseProperties.attendance:
              value[FirebaseProperties.attendance] == 'Present' ? true : false
        }).then((value) async {
          await documentReference.delete();
        });
      } on FirebaseException catch (e) {
        developer.log(e.message!);
        return TaskStatus.failFirebase;
      }

      String avatarKeyNew = '${formClassroom}_$formName';
      await saveImageData(bytes: bytes, avatarKey: avatarKeyNew, ref: ref);
    } else {
      try {
        await documentReference.set({
          'gender': value[FirebaseProperties.gender],
          'classroom': formClassroom,
          'house': value[FirebaseProperties.house],
          'points': int.parse(value[FirebaseProperties.points]),
          'present':
              value[FirebaseProperties.attendance] == 'Present' ? true : false
        });
      } on FirebaseException catch (e) {
        developer.log(e.message!);
        return TaskStatus.failFirebase;
      }
    }

    return TaskStatus.success;
  }
}

Future<int> deleteClassrooms({required Set<String> classrooms}) async {
  final classroomCollection = await FirebaseFirestore.instance
      .collection(FirebaseProperties.collectionClassrooms)
      .get();
  try {
    for (var c in classroomCollection.docs) {
      await c.reference.delete();
    }
  } on FirebaseException catch (e) {
    developer.log(e.message!);
    return 400;
  }
  return 200;
}

Future<int> deleteStudents({required Set<Student> students}) async {
  final studentCollection = FirebaseFirestore.instance
      .collection(FirebaseProperties.collectionClassrooms);

  try {
    for (var s in students) {
      await studentCollection
          .doc(s.classroom)
          .collection(FirebaseProperties.collectionStudents)
          .doc(s.name)
          .delete();
    }
  } on FirebaseException catch (e) {
    developer.log(e.message!);
    return 400;
  }
  return 200;
}

void formSubmittedStudents({
  required BuildContext context,
  required List<GlobalKey<FormBuilderState>> formKeys,
  required WidgetRef ref,
  required String classroom,
}) {
  final students = getStudentsFromForm(formKeys: formKeys);

  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (context) => LoadingHelper(
        future: addStudentsToFirebase(students: students, ref: ref),
        onFutureComplete: (taskResult) {
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
              builder: (context) => ClassroomMain(classroom: classroom),
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
  if (classrooms.length > 1) {
    message = 'Classrooms added';
  }

  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (context) => LoadingHelper(
        future: addClassroomsToFirebase(classrooms: classrooms),
        onFutureComplete: (error) {
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

Future<bool> checkIfStudentExistsInClassroom(
    {required GlobalKey<FormBuilderState> formKey}) async {
  final classroom = formKey.currentState!.value[FirebaseProperties.classroom];
  final name = formKey.currentState!.value[FirebaseProperties.name];

  final doc = await FirebaseFirestore.instance
      .collection(FirebaseProperties.collectionClassrooms)
      .doc(classroom)
      .collection(FirebaseProperties.collectionStudents)
      .doc(name)
      .get();
  if (doc.exists) {
    return true;
  } else {
    return false;
  }
}
