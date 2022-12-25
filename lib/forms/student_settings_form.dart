
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../data/houses.dart';
import '../models/student.dart';
import '../state/simple_providers.dart';
import '../utils/constants.dart';
import '../utils/enums/gender.dart';
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    getValues() {
      final validated = _formKey.currentState!.isValid;
      if (validated) {
        _formKey.currentState!.save();
        updateStudentDetails();
      }
    }

    return FormBuilder(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            CustomTextField(initialValue: widget.student.name, name: 'name'),
            CustomDropDown(
              values: Gender.values.map((e) => e.toText()).toList(),
              name: kGender,
              initialValue: widget.student.gender.toText(),
            ),
            CustomDropDown(
              name: kHouse,
              values: houses,
              initialValue: widget.student.house,
            ),
            CustomDropDown(
              name: kPresent,
              values: ["Present", "Absent"],
              initialValue: widget.student.present ? "Present" : "Absent",
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Align(alignment:
                  Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16, left: 16),
                      child: Text('Points', style: Theme.of(context).textTheme.headlineSmall,),
                    ),),),
                Expanded(
                  child: CustomNumberField(
                    name: kPoints,
                    initialValue: widget.student.points.toString(),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            ElevatedButton(
                onPressed: () {
                  getValues();
                },
                child: const Text('Submit Changes'))
          ],
        ),
      ),
    );
  }



updateStudentDetails(){


  final documentReference = FirebaseFirestore.instance
      .collection(kCollectionClassrooms)
      .doc('B1')
      .collection(kCollectionStudents)
      .doc(widget.student.name);

  final value = _formKey.currentState!.value;
  Uint8List imageBytes;
  String formName = value[kName];
  if (widget.student.name != formName) {
    print('NAME CHANGED');

    FirebaseFirestore.instance
        .collection(kCollectionClassrooms)
        .doc('B1')
        .collection(kCollectionStudents)
        .doc(formName)
        .set({
      kGender: value[kGender],
      kClassroom: 'B1',
      kHouse: value[kHouse],
      kPoints: value[kPoints],
      kPresent: value[kPresent]
    });

    String avatarKey =
        '${widget.student.classRoom}_${widget.student.name}';
    imageBytes = ref
        .read(avatarProvider)
        .firstWhere((element) => element.avatarKey == avatarKey)
        .bytes;
    FirebaseStorage.instance
        .ref('$kAvatarsBucket/${widget.student.classRoom}_$formName')
        .putData(imageBytes);
  } else {
    print('name not chnged');
  }

  documentReference.set({
    'gender': value[kGender],
    'classroom': 'B1',
    'house': value[kHouse],
    'points': int.parse(value[kPoints]),
    'present': value[kPresent] == 'Present' ? true : false
  });
}


  }
