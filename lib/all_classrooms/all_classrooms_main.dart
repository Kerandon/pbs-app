import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pbs_app/configs/ui_constants.dart';
import 'package:pbs_app/utils/app_messages.dart';
import '../app/components/loading_page.dart';
import '../utils/firebase_properties.dart';
import 'classroom_tile.dart';

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
        .collection(FirebaseProperties.collectionClassrooms)
        .snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return StreamBuilder<QuerySnapshot>(
        stream: _classroomStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          Set<String> classrooms = {};

          if (snapshot.hasData) {
            final data = snapshot.data;
            for (var d in data!.docs) {
              classrooms.add(d.id);
            }
            return Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).secondaryHeaderColor, width: 6),
                    borderRadius: BorderRadius.circular(kBorderRadius),
                  ),
                  width: size.width * 0.90,
                  height: size.height * 0.80,

                  child: classrooms.isNotEmpty ? GridView.builder(
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
                    itemBuilder: (context, index) =>
                        ClassroomTile(classroom: classrooms.elementAt(index)),
                  ) : Center(child: Padding(
                    padding: EdgeInsets.all(size.width * 0.10),
                    child: Text(AppMessages.getStartedByAddingClassrooms,
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Colors.black54),
                      textAlign: TextAlign.center,),
                  ))
                ),
              ),
            );
          }
          return const LoadingPage();
        });
  }
}
