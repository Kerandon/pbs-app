import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pbs_app/home_page.dart';
import 'package:pbs_app/models/student.dart';
import 'package:pbs_app/utils/app_messages.dart';
import 'package:pbs_app/utils/methods/pop_ups.dart';
import 'package:pbs_app/utils/methods/route_methods.dart';
import '../../app/components/loading_helper.dart';
import '../../classroom/classroom_main.dart';
import '../firebase_properties.dart';
import '../enums/task_result.dart';
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
      classRoom: value[FirebaseProperties.classroom],
      house: value[FirebaseProperties.house],
    ));
  }

  return students;
}

Future<TaskResult> addClassroomsToFirebase(
    {required List<String> classrooms}) async {
  try {
    for (var c in classrooms) {
      await FirebaseFirestore.instance
          .collection(FirebaseProperties.collectionClassrooms)
          .doc(c)
          .set({});
    }
  } on FirebaseException catch (e) {
    developer.log(e.message!);
    return TaskResult.failFirebase;
  }

  return TaskResult.success;
}

Future<TaskResult> addStudentsToFirebase(
    {required List<Student> students, required WidgetRef ref}) async {
  try {
    final classroomCollection = FirebaseFirestore.instance
        .collection(FirebaseProperties.collectionClassrooms);
    for (var s in students) {
      final doc = await classroomCollection
          .doc(s.classroom)
          .collection(FirebaseProperties.collectionStudents)
          .doc(s.name)
          .get();
      if (doc.exists) {
        return TaskResult.failStudentAlreadyExists;
      } else {
        await FirebaseFirestore.instance
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
            FirebaseProperties.attendance: true,
            FirebaseProperties.topPoints: false,
          },
        );
        await generateAvatar(student: s, ref: ref);
      }
    }
  } on FirebaseException catch (e) {
    developer.log('failed creating ${e.message!}');
    return TaskResult.failFirebase;
  }
  return TaskResult.success;
}

Future<TaskResult> updateStudentDetails({
  required Student student,
  required GlobalKey<FormBuilderState> formKey,
  required WidgetRef ref,
}) async {
  final value = formKey.currentState!.value;

  try {
    final documentReference = FirebaseFirestore.instance
        .collection(FirebaseProperties.collectionClassrooms)
        .doc(student.classroom)
        .collection(FirebaseProperties.collectionStudents)
        .doc(student.name);

    if (student.name == value[FirebaseProperties.name] &&
        student.classroom == value[FirebaseProperties.classroom]) {
      await documentReference.set({
        FirebaseProperties.gender : value[FirebaseProperties.gender],
        FirebaseProperties.classroom : value[FirebaseProperties.classroom],
        FirebaseProperties.house : value[FirebaseProperties.house],
        FirebaseProperties.points : int.parse(value[FirebaseProperties.points]),
        FirebaseProperties.attendance :
            value[FirebaseProperties.attendance] == 'Present' ? true : false,
        FirebaseProperties.topPoints: false,
      });
    } else {
      bool alreadyExists =
          await checkIfStudentExistsInClassroom(formKey: formKey);

      if (alreadyExists) {
        return TaskResult.failStudentAlreadyExists;
      } else {
        Uint8List bytes;
        String formName = value[FirebaseProperties.name];
        String formClassroom = value[FirebaseProperties.classroom];

        String avatarKeyCurrent = '${student.classroom}_${student.name}';

        bytes = ref
            .read(avatarProvider)
            .firstWhere((element) => element.avatarKey == avatarKeyCurrent)
            .bytes;

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
              value[FirebaseProperties.attendance] == 'Present' ? true : false,
          FirebaseProperties.topPoints: false,
        }).then((value) async {
          await documentReference.delete();
        });

        String avatarKeyNew = '${formClassroom}_$formName';
        await saveImageData(bytes: bytes, avatarKey: avatarKeyNew, ref: ref);
      }
    }
  } on FirebaseException catch (e) {
    developer.log(e.message!);
    return TaskResult.failFirebase;
  }
  return TaskResult.success;
}

Future<TaskResult> deleteClassrooms({required Set<String> classrooms}) async {
  try {
    final classroomCollection = await FirebaseFirestore.instance
        .collection(FirebaseProperties.collectionClassrooms)
        .get();

    for (var c in classroomCollection.docs) {
      await c.reference.delete();
    }
  } on FirebaseException catch (e) {
    developer.log(e.message!);
    return TaskResult.failFirebase;
  }
  return TaskResult.success;
}

Future<TaskResult> deleteStudents(
    {required Set<Student> students, required WidgetRef ref}) async {
  try {
    final studentCollection = FirebaseFirestore.instance
        .collection(FirebaseProperties.collectionClassrooms);

    for (var s in students) {
      await studentCollection
          .doc(s.classroom)
          .collection(FirebaseProperties.collectionStudents)
          .doc(s.name)
          .delete();
      await removeImageData(avatarKey: '${s.classroom}_${s.name}', ref: ref);
    }
  } on FirebaseException catch (e) {
    developer.log(e.message!);
    return TaskResult.failFirebase;
  }
  return TaskResult.success;
}

Future<void> formSubmittedStudents({
  required BuildContext context,
  required List<GlobalKey<FormBuilderState>> formKeys,
  required WidgetRef ref,
  required String classroom,
}) async {
  final students = getStudentsFromForm(formKeys: formKeys);

  await pushRoute(
    context,
    LoadingHelper(
      future: addStudentsToFirebase(students: students, ref: ref),
      onFutureComplete: (taskResult) async {
        String scaffoldMessage = AppMessages.studentSuccessfullyAdded;
        if (formKeys.length > 1) {
          scaffoldMessage = AppMessages.studentsSuccessfullyAdded;
        }
        if (taskResult == TaskResult.failStudentAlreadyExists) {
          scaffoldMessage = AppMessages.studentAlreadyExistsInClass;
        }
        if (taskResult == TaskResult.failFirebase) {
          scaffoldMessage == AppMessages.errorFirebaseConnection;
        }

        showSnackBarMessage(context, scaffoldMessage);

        await pushReplacementRoute(
            context, ClassroomMain(classroom: classroom));
      },
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

  try {
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
  } on FirebaseException catch (e) {
    developer.log(e.message!);
    return false;
  }
}
