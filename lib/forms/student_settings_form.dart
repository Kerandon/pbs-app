import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pbs_app/classroom/classroom_main.dart';
import 'package:pbs_app/classroom/student_settings.dart';
import 'package:pbs_app/utils/app_messages.dart';
import 'package:pbs_app/utils/enums/attendance.dart';
import 'package:pbs_app/utils/enums/task_result.dart';
import 'package:pbs_app/utils/methods/route_methods.dart';
import '../app/components/loading_helper.dart';
import '../app/components/loading_page.dart';
import '../utils/firebase_properties.dart';
import '../data/houses.dart';
import '../models/student.dart';
import '../utils/enums/gender.dart';
import '../utils/methods/methods_forms.dart';
import 'custom_dropdown.dart';
import 'custom_number_field.dart';
import 'custom_text_field.dart';

class StudentSettingsForm extends ConsumerStatefulWidget {
  const StudentSettingsForm({
    required this.student,
    super.key,
  });

  final Student student;

  @override
  ConsumerState<StudentSettingsForm> createState() =>
      _StudentSettingsFormState();
}

class _StudentSettingsFormState extends ConsumerState<StudentSettingsForm> {
  late final Stream<QuerySnapshot> _allClassroomsStream;

  final _formKey = GlobalKey<FormBuilderState>();

  bool _haveNewValue = false;

  Map<String, bool> newValueStates = {};

  valueEntered({required String name, required bool isNew}) {
    newValueStates.addAll({name: isNew});

    _haveNewValue = newValueStates.entries.any((element) => element.value);

    setState(() {});
  }

  @override
  void initState() {
    _allClassroomsStream = FirebaseFirestore.instance
        .collection(FirebaseProperties.collectionClassrooms)
        .snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return StreamBuilder<QuerySnapshot>(
        stream: _allClassroomsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          List<String> classrooms = [];

          if (snapshot.hasData) {
            final docs = snapshot.data!.docs;
            for (var d in docs) {
              classrooms.add(d.id);
            }

            return FormBuilder(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      initialValue: widget.student.name,
                      name: FirebaseProperties.name,
                      leading: 'Name',
                      newValueEntered: (newValue) {
                        valueEntered(
                            isNew: newValue, name: FirebaseProperties.points);
                      },
                    ),
                    CustomDropDown(
                      values: classrooms.toList(),
                      name: FirebaseProperties.classroom,
                      leading: 'Classroom',
                      initialValue: widget.student.classroom,
                      newValueEntered: (newValue) {
                        valueEntered(
                            isNew: newValue,
                            name: FirebaseProperties.classroom);
                      },
                    ),
                    CustomDropDown(
                      values: Gender.values.map((e) => e.toText()).toList(),
                      name: FirebaseProperties.gender,
                      initialValue: widget.student.gender.toText(),
                      leading: 'Gender',
                      newValueEntered: (newValue) {
                        valueEntered(
                          isNew: newValue,
                          name: FirebaseProperties.gender,
                        );
                      },
                    ),
                    CustomDropDown(
                      name: FirebaseProperties.house,
                      values: houses,
                      initialValue: widget.student.house,
                      leading: 'House',
                      newValueEntered: (newValue) {
                        valueEntered(
                          isNew: newValue,
                          name: FirebaseProperties.house,
                        );
                      },
                    ),
                    CustomDropDown(
                      name: FirebaseProperties.attendance,
                      values: Attendance.values.map((e) => e.toText()).toList(),
                      initialValue: widget.student.present
                          ? Attendance.present.toText()
                          : Attendance.absent.toText(),
                      leading: 'Attendance',
                      newValueEntered: (newValue) {
                        valueEntered(
                            isNew: newValue,
                            name: FirebaseProperties.attendance);
                      },
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomNumberField(
                            name: FirebaseProperties.points,
                            initialValue: widget.student.points.toString(),
                            leading: 'Points',
                            newValueEntered: (newValue) {
                              valueEntered(
                                isNew: newValue,
                                name: FirebaseProperties.points,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    SizedBox(
                      width: size.width,
                      child: OutlinedButton(
                          onPressed: _haveNewValue
                              ? () {
                                  final validated =
                                      _formKey.currentState!.isValid;
                                  if (validated) {
                                    _formKey.currentState!.save();

                                    final futureDetails = updateStudentDetails(
                                      student: widget.student,
                                      formKey: _formKey,
                                      ref: ref,
                                    );
                                    pushRoute(
                                      context,
                                      LoadingHelper(
                                          future: futureDetails,
                                          onFutureComplete: (taskResult) {
                                            if (taskResult ==
                                                TaskResult
                                                    .failStudentAlreadyExists) {
                                              Navigator.of(context)
                                                  .pushAndRemoveUntil(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              StudentSettings(
                                                                  student: widget
                                                                      .student)),
                                                      (route) => false);

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(AppMessages
                                                      .studentAlreadyExistsInClass),
                                                ),
                                              );
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(AppMessages
                                                      .studentDetailsSaved),
                                                ),
                                              );
                                              pushReplacementRoute(
                                                  context,
                                                  ClassroomMain(
                                                      classroom: widget
                                                          .student.classroom),);
                                            }
                                          },),
                                    );
                                  }
                                }
                              : null,
                          child: const Text('Save changed details')),
                    )
                  ],
                ),
              ),
            );
          }
          return const LoadingPage();
        });
  }
}
