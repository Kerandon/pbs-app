import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pbs_app/app/components/confirmation_box.dart';
import 'package:pbs_app/app/components/loading_helper.dart';
import 'package:pbs_app/classroom/classroom_main.dart';
import 'package:pbs_app/classroom/remove_students.dart';
import 'package:pbs_app/utils/methods/points_methods.dart';
import 'package:pbs_app/utils/methods/pop_ups.dart';
import 'package:pbs_app/utils/methods/route_methods.dart';
import '../forms/form_main.dart';
import '../models/student.dart';
import '../utils/app_messages.dart';
import '../utils/enums/form_types.dart';
import '../utils/enums/task_result.dart';

class ClassroomDrawer extends ConsumerWidget {
  const ClassroomDrawer({
    required this.classroom,
    required this.students,
    super.key,
  });

  final String classroom;
  final Set<Student> students;



  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int classPoints = 0;

    for(var s in students){
      int points = s.points;
      classPoints += points;
    }

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
                  builder: (context) => FormMain(
                    formType: FormType.student,
                    classroom: classroom,
                    title: 'Add students',
                    onExitPage: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) =>
                              ClassroomMain(classroom: classroom),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.remove),
            title: const Text('Remove students'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      RemoveStudentsPage(classroom: classroom),
                ),
              );
            },
          ),
          const Divider(
            color: Colors.grey,
          ),
          ListTile(
            leading: const Icon(Icons.celebration_outlined,),
            title: const Text('Award all students 1 point'),
            onTap: () {
              pushRoute(
                context,
                LoadingHelper(
                  future: awardAllStudentsOnePoint(classroom: classroom),
                  onFutureComplete: (taskResult) async {
                    if (taskResult == TaskResult.success) {
                      showSnackBarMessage(
                          context, AppMessages.allStudentsAwardedAPoint);
                      await pushReplacementRoute(
                          context, ClassroomMain(classroom: classroom));
                    }
                    if (taskResult == TaskResult.failFirebase) {
                      if (context.mounted) {
                        showSnackBarMessage(
                            context, AppMessages.errorFirebaseConnection);
                      }
                    }
                  },
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.refresh_outlined),
            title: const Text('Clear all points'),
            onTap: classPoints > 0 ? () {
              showDialog(
                context: context,
                builder: (context) => ConfirmationBox(
                  title: AppMessages.confirmBoxClearAllPoints,
                  voidCallBack: () => pushRoute(
                    context,
                    LoadingHelper(
                          future: clearAllStudentsPoints(classroom: classroom),
                          onFutureComplete: (taskResult) async {
                            if (taskResult == TaskResult.success) {

                              showSnackBarMessage(
                                  context, AppMessages.allPointsCleared);
                            }
                            await pushReplacementRoute(context, ClassroomMain(classroom: classroom));
                          },


                    ),
                  ),
                ),
              );
            } : null,
          ),
        ],
      ),
    );
  }
}
