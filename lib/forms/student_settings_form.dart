import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pbs_app/classroom/student_settings.dart';
import 'package:pbs_app/utils/enums/attendance.dart';
import '../app/components/loading_helper.dart';
import '../data/houses.dart';
import '../models/student.dart';
import '../configs/constants.dart';
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
  final _formKey = GlobalKey<FormBuilderState>();

  bool _haveNewValue = false;

  Map<String, bool> newValueStates = {};

  valueEntered({required String name, required bool isNew}) {
    newValueStates.addAll({name: isNew});

    _haveNewValue = newValueStates.entries.any((element) => element.value);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return FormBuilder(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            CustomTextField(
              initialValue: widget.student.name,
              name: 'name',
              newValueEntered: (newValue) {
                valueEntered(isNew: newValue, name: kPoints);
              },
            ),
            CustomDropDown(
              values: Gender.values.map((e) => e.toText()).toList(),
              name: kGender,
              initialValue: widget.student.gender.toText(),
              newValueEntered: (newValue) {
                valueEntered(isNew: newValue, name: kGender);
              },
            ),
            CustomDropDown(
              name: kHouse,
              values: houses,
              initialValue: widget.student.house,
              newValueEntered: (newValue) {
                valueEntered(isNew: newValue, name: kHouse);
              },
            ),
            CustomDropDown(
              name: kAttendance,
              values: Attendance.values.map((e) => e.toText()).toList(),
              initialValue: widget.student.present
                  ? Attendance.present.toText()
                  : Attendance.absent.toText(),
              newValueEntered: (newValue) {
                valueEntered(isNew: newValue, name: kAttendance);
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16, left: 16),
                      child: Text(
                        'Points',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: CustomNumberField(
                    name: kPoints,
                    initialValue: widget.student.points.toString(),
                    newValueEntered: (newValue) {
                      valueEntered(isNew: newValue, name: kPoints);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            OutlinedButton(
                onPressed: _haveNewValue
                    ? () {
                        final validated = _formKey.currentState!.isValid;
                        if (validated) {
                          _formKey.currentState!.save();
                          final futureDetails = updateStudentDetails(
                              student: widget.student,
                              formKey: _formKey,
                              ref: ref);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => LoadingHelper(
                                future: futureDetails,
                                onFutureComplete: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Student details saved'),
                                    ),
                                  );

                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) => StudentSettings(
                                              student: widget.student)),
                                      (route) => false);
                                },
                              ),
                            ),
                          );
                        }
                      }
                    : null,
                child: const Text('Change details'))
          ],
        ),
      ),
    );
  }
}
