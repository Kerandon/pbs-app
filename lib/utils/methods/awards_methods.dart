import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pbs_app/utils/firebase_properties.dart';
import 'dart:developer' as developer;
import '../../models/student.dart';
import '../enums/task_result.dart';

Future<Map<String, String>> getAllAwardImages({Set<String>? awardNames}) async {
  Map<String, String> awards = {};

  try {
    final awardsList = await FirebaseStorage.instance
        .ref(FirebaseProperties.awardsBucket)
        .listAll();

    for (var item in awardsList.items) {
      if (awardNames == null) {
        awards.addAll(
          {
            item.name: await item.getDownloadURL(),
          },
        );
      } else {
        if (awardNames.contains(item.name)) {
          awards.addAll(
            {
              item.name: await item.getDownloadURL(),
            },
          );
        }
      }
    }
  } on FirebaseException catch (e) {
    developer.log(e.message!);
  }

  return awards;
}

Future<TaskResult> giveAward(
    {required Student student, required String award}) async {
  try {
    await FirebaseFirestore.instance
        .collection(FirebaseProperties.collectionClassrooms)
        .doc(student.classroom)
        .collection(FirebaseProperties.collectionStudents)
        .doc(student.name)
        .collection(FirebaseProperties.awardsCollection)
        .doc(FirebaseProperties.awardsAll)
        .set({award: FieldValue.increment(1)}, SetOptions(merge: true));
  } on FirebaseException catch (e) {
    developer.log(e.message!);
    return TaskResult.failFirebase;
  }
  return TaskResult.success;
}
