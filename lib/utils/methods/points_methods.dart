import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pbs_app/utils/firebase_properties.dart';
import 'package:pbs_app/utils/enums/task_result.dart';

import '../../models/student.dart';

import 'dart:developer' as developer;

Future<TaskResult> awardStudentOnePoint(
    {required DocumentReference<Map<String, dynamic>> documentRef}) async {
  try {
    await documentRef.update(
      {'points': FieldValue.increment(1)},
    );
  } on FirebaseException catch (e) {
    developer.log(e.message!);
    return TaskResult.failFirebase;
  }

  return TaskResult.success;
}

Future<TaskResult> awardAllStudentsOnePoint(
    {required final String classroom}) async {
  try {
    final allStudents = await FirebaseFirestore.instance
        .collection(FirebaseProperties.collectionClassrooms)
        .doc(classroom)
        .collection(FirebaseProperties.collectionStudents)
        .get();

    for (var s in allStudents.docs) {
      await s.reference
          .update({FirebaseProperties.points: FieldValue.increment(1)});
    }
  } on FirebaseException catch (e) {
    developer.log(e.message!);
    return TaskResult.failFirebase;
  }
  return TaskResult.success;
}

Future<TaskResult> clearPoints({required Student student}) async {
  try {
    await FirebaseFirestore.instance
        .collection(FirebaseProperties.collectionClassrooms)
        .doc(student.classroom)
        .collection(FirebaseProperties.collectionStudents)
        .doc(student.name)
        .update({'points': 0});
  } on FirebaseException catch (e) {
    developer.log(e.message!);
    return TaskResult.failFirebase;
  }
  return TaskResult.success;
}

Future<TaskResult> clearAllStudentsPoints({required String classroom}) async {
  try {
    final allStudents = await FirebaseFirestore.instance
        .collection(FirebaseProperties.collectionClassrooms)
        .doc(classroom)
        .collection(FirebaseProperties.collectionStudents)
        .get();

    for (var s in allStudents.docs) {
      await clearPoints(student: Student.fromJson(name: s.id, json: s.data()));
    }
  } on FirebaseException catch (e) {
    developer.log(e.message!);
    return TaskResult.failFirebase;
  }

  return TaskResult.success;
}


void setTopPointsScorers({required Set<Student> students}) {
  if(students.isNotEmpty) {
    List<Student> studentsList = students.toList();
    studentsList.sort((a, b) => b.points.compareTo(a.points));
    Set<Student> topPointsStudents = {studentsList.first};
    for (var s in studentsList) {
      if (s.points == topPointsStudents.first.points) {
        topPointsStudents.add(s);
      }
    }

    for (var s in students) {

      bool isTop = topPointsStudents.contains(s);

      FirebaseFirestore.instance.collection(
          FirebaseProperties.collectionClassrooms)
          .doc(s.classroom).collection(
          FirebaseProperties.collectionStudents)
          .doc(s.name).update(
          {FirebaseProperties.topPoints: isTop});
    }
  }
}

