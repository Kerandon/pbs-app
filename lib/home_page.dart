import 'package:flutter/material.dart';
import 'package:pbs_app/all_classrooms/remove_classrooms.dart';
import 'package:pbs_app/forms/form_main.dart';
import 'package:pbs_app/utils/enums/form_types.dart';

import 'all_classrooms/all_classrooms_main.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('PBS Tracker',),
        centerTitle: true,
      ),
      endDrawer: Drawer(
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
            ),
            ListTile(
              leading: const Icon(Icons.remove),
              title: const Text('Remove classrooms'),
              onTap: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const RemoveClassrooms(),
                ),
              ),
            )
          ],
        ),
      ),
      body: const AllClassroomsMain(),
    );
  }
}
