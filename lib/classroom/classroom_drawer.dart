import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pbs_app/classroom/remove_students_page.dart';
import '../forms/form_main.dart';
import '../utils/enums/form_types.dart';

class ClassroomDrawer extends ConsumerWidget {
  const ClassroomDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return Drawer(
      child: Column(
        children: [
          SizedBox(
            height: size.height * 0.10,
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Add students'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const FormMain(
                    formType: FormType.student,
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.remove),
            title: const Text('Remove students'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const RemoveStudentsPage()));
            },
          )
        ],
      ),
    );
  }
}
