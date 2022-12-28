
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../app/components/loading_page.dart';
import '../configs/constants.dart';

class AllClassroomsMain extends StatefulWidget {
  const AllClassroomsMain({
    super.key,
  });

  @override
  State<AllClassroomsMain> createState() => _AllClassroomsMainState();
}

class _AllClassroomsMainState extends State<AllClassroomsMain> {

  late final Stream<QuerySnapshot<Map<String, dynamic>>> _classroomStream;

  @override
  void initState() {
    _classroomStream = FirebaseFirestore.instance
        .collection(kCollectionClassrooms)
        .snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return StreamBuilder<QuerySnapshot>(
        stream: _classroomStream,
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          Set<String> classrooms = {};

          if (snapshot.hasData) {
            final data = snapshot.data;
            for (var d in data!.docs) {
              classrooms.add(d.id);
            }
            return GridView.builder(
              itemCount: classrooms.length,
              padding: EdgeInsets.only(
                left: size.width * 0.05,
                top: size.width * 0.05,
                right: size.width * 0.05,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemBuilder: (context, index) => Container(
                color: Colors.green,
                child: Text(classrooms.elementAt(index)),
              ),
            );
          }
          return LoadingPage();
        });
  }
}
