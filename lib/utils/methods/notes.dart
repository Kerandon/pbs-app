import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pbs_app/utils/enums/task_result.dart';

import '../../models/note.dart';
import '../../models/student.dart';
import '../firebase_properties.dart';
import 'dart:developer' as developer;

Future<TaskResult> saveNoteToFirebase(
    {required Student student,
    required String note,
    required int index}) async {
  DateTime dateTime = DateTime.now();

  try {
    FirebaseFirestore.instance
        .collection(FirebaseProperties.collectionClassrooms)
        .doc(student.classroom)
        .collection(FirebaseProperties.collectionStudents)
        .doc(student.name)
        .collection(FirebaseProperties.collectionNotes)
        .doc(index.toString())
        .set(
            {FirebaseProperties.date: dateTime, FirebaseProperties.note: note});
  } on FirebaseException catch (e) {
    developer.log(e.message!);
    return TaskResult.failFirebase;
  }
  return TaskResult.success;
}

Future<TaskResult> deleteNotes(
    {required Student student, required List<Note> notes}) async {
  try {
    for (var n in notes) {
      await FirebaseFirestore.instance
          .collection(FirebaseProperties.collectionClassrooms)
          .doc(student.classroom)
          .collection(FirebaseProperties.collectionStudents)
          .doc(student.name)
          .collection(FirebaseProperties.collectionNotes)
          .doc(n.index.toString())
          .delete();
    }
  } on FirebaseException catch (e) {
    developer.log(e.message!);
    return TaskResult.failFirebase;
  }

  return TaskResult.success;
}
