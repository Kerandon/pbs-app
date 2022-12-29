import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pbs_app/utils/firebase_properties.dart';
import 'package:pbs_app/utils/enums/task_status.dart';

import '../../models/student.dart';

import 'dart:developer' as developer;

Future<TaskStatus> clearPoints({required Student student}) async {
  try {
    await FirebaseFirestore.instance
        .collection(FirebaseProperties.collectionClassrooms)
        .doc(student.classroom)
        .collection(FirebaseProperties.collectionStudents)
        .doc(student.name)
        .update({'points': 0});
    return TaskStatus.success;
  } on FirebaseException catch (e) {
    developer.log(e.message!);
    return TaskStatus.failFirebase;
  }
}
