import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pbs_app/app/components/loading_page.dart';
import 'package:pbs_app/configs/constants.dart';
import 'package:pbs_app/forms/form_main.dart';
import 'package:pbs_app/utils/enums/form_types.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.10,
            ),
            ListTile(
              leading: const Icon(
                Icons.add,
              ),
              title: const Text('Add classrooms'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FormMain(
                      formType: FormType.classroom,
                      title: 'Add classrooms',
                      onExitPage: () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => const HomePage()),
                      ),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _classroomStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            Set<String> classrooms = {};

            if (snapshot.hasData) {
              final data = snapshot.data;
              for (var d in data!.docs) {
                print(d.id);
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
                      ),);

            }
            return LoadingPage();
          }),
    );
  }
}
