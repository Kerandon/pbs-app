import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import '../data/houses.dart';
import '../utils/enums/gender.dart';
import 'custom_dropdown.dart';
import 'custom_textfield.dart';

class StudentForm extends StatefulWidget {
  const StudentForm({
    super.key,
    required this.index,
    this.removeDivider = false,
    required this.formKey,
  });

  final int index;
  final bool removeDivider;
  final GlobalKey<FormBuilderState> formKey;

  @override
  State<StudentForm> createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  late final List<CustomDropDown> dropDowns;

  @override
  void initState() {
    dropDowns = [
      CustomDropDown(
        boxLabel: "gender",
        values: Gender.values.map((e) => e.toText()).toList(),
      ),
      CustomDropDown(boxLabel: "house", values: houses),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(

              name: 'name',
              boxLabel:
                  'Enter student name ${(widget.index + 1).toString()}'),
          Column(
            children: dropDowns,
          ),
          widget.removeDivider
              ? const SizedBox()
              : const Padding(
                padding: EdgeInsets.all(12.0),
                child: Divider(
                    thickness: 1,
                  ),
              ),
        ],
      ),
    );
  }
}
