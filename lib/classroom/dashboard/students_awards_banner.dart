
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';import '../../models/student.dart';


import '../../utils/firebase_properties.dart';
import '../../utils/methods/awards_methods.dart';

class StudentsAwardsBanner extends StatefulWidget {
  const StudentsAwardsBanner({
    super.key,
    required this.student,
  });

  final Student student;

  @override
  State<StudentsAwardsBanner> createState() => _StudentsAwardsBannerState();
}

class _StudentsAwardsBannerState extends State<StudentsAwardsBanner> {
  late final Stream<DocumentSnapshot<Map<String, dynamic>>> _awardsStream;

  @override
  initState() {
    _awardsStream = FirebaseFirestore.instance
        .collection(FirebaseProperties.collectionClassrooms)
        .doc(widget.student.classroom)
        .collection(FirebaseProperties.collectionStudents)
        .doc(widget.student.name)
        .collection(FirebaseProperties.awardsCollection)
        .doc(FirebaseProperties.awardsAll)
        .snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: size.height * 0.05,
      child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: _awardsStream,
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!.data();

            Set<String> awardNames = {};

            if (data != null) {
              for (var d in data.entries) {
                awardNames.add(d.key);
              }

              return FutureBuilder(
                future: getAllAwardImages(awardNames: awardNames),
                builder: (context, snapshot) {
                  Map<String, String> awardMaps = {};

                  if (snapshot.hasData) {
                    awardMaps.addEntries(snapshot.data!.entries);

                    return awardMaps.isNotEmpty
                        ? Image.network(awardMaps.entries.first.value)
                        : SizedBox();
                  }
                  return SizedBox();
                },
              );
            }
          }
          return SizedBox();
        },
      ),
    );
  }
}
