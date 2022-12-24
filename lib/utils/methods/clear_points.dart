import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/student.dart';
import '../constants.dart';

Future<int> clearPoints({required Student student}) async {
  await FirebaseFirestore.instance.collection(kCollectionClassrooms).doc('B1')
      .collection(kCollectionStudents).doc(student.name).update(
      {'points': 0});
  return 200;
}