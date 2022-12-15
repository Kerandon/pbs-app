import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../enums/gender.dart';
import '../data/houses.dart';

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
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return FormBuilder(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text('Add new student ${(widget.index + 1).toString()}'),
          ),
          FormBuilderTextField(
            name: 'name',
            decoration: const InputDecoration(
                isDense: true,
                label: Text('Student name'), border: OutlineInputBorder()),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter a name";
              }
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          SizedBox(
            height: size.height * 0.02,
          ),
          FormBuilderDropdown(
            name: 'gender',
            initialValue: Gender.male.name,
            items: Gender.values
                .map(
                  (e) => DropdownMenuItem<String>(
                    value: e.name,
                    child: Text(
                      e.toText(),
                    ),
                  ),
                )
                .toList(),
            decoration: const InputDecoration(
              isDense: true,
              label: Text('Gender'),
              border: OutlineInputBorder(),
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          SizedBox(
            height: size.height * 0.02,
          ),
          FormBuilderDropdown(
            name: 'house',
            initialValue: houses.first,
            items: houses
                .map(
                  (e) => DropdownMenuItem<String>(
                    value: e,
                    child: Text(e),
                  ),
                )
                .toList(),
            decoration: const InputDecoration(
              isDense: true,
              label: Text('House'),
              border: OutlineInputBorder(),
            ),
          ),
          widget.removeDivider
              ? const SizedBox()
              : const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Divider(
                    thickness: 2,
                  ),
                )
        ],
      ),
    );
  }
}
