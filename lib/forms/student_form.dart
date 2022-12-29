import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pbs_app/utils/app_messages.dart';
import 'package:pbs_app/utils/firebase_properties.dart';
import '../app/components/loading_page.dart';
import '../data/houses.dart';
import '../utils/enums/gender.dart';
import 'custom_dropdown.dart';
import 'custom_text_field.dart';

class StudentForm extends StatefulWidget {
  const StudentForm({
    super.key,
    required this.index,
    required this.formKey,
    this.isValidated,
  });

  final int index;
  final GlobalKey<FormBuilderState> formKey;
  final Function(bool isValidated)? isValidated;

  @override
  State<StudentForm> createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  late final Stream<QuerySnapshot> _allClassroomsStream;

  final Map<String, bool> _validatorTracker = {};

  _updateValidator({required String name, required bool isValidated}) {
    _validatorTracker.addAll({name: isValidated});

    if (_validatorTracker.entries.every((element) => element.value)) {
      widget.isValidated?.call(true);
    } else {
      widget.isValidated?.call(false);
    }
  }

  @override
  void initState() {
    _allClassroomsStream = FirebaseFirestore.instance
        .collection(FirebaseProperties.collectionClassrooms)
        .snapshots();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _validatorTracker.addAll({
        FirebaseProperties.name: false,
        FirebaseProperties.classroom :
        true,
        FirebaseProperties.gender : false,
        FirebaseProperties.house : false
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _allClassroomsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            List<String> allClasses = [];
            if (snapshot.hasData) {
              for (var d in snapshot.data!.docs) {
                allClasses.add(d.id);
              }

              final List<CustomDropDown> dropDowns = [
                CustomDropDown(
                  name: FirebaseProperties.gender,
                  hintText: AppMessages.kPleaseSelect,
                  leading: 'Gender',
                  values: Gender.values.map((e) => e.toText()).toList(),
                  isValidated: (isValid) {
                    _updateValidator(name: FirebaseProperties.gender, isValidated: isValid);
                  },
                ),
                CustomDropDown(
                  name: FirebaseProperties.name,
                  hintText: 'Classroom',
                  values: allClasses,
                  isValidated: (isValid) {
                    _updateValidator(name: FirebaseProperties.classroom, isValidated: isValid);
                  },
                ),
                CustomDropDown(
                  name: FirebaseProperties.house,
                  hintText: 'House',
                  values: houses,
                  isValidated: (isValid) {
                    _updateValidator(name: FirebaseProperties.house, isValidated: isValid);
                  },
                ),
              ];

              return FormBuilder(
                key: widget.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.person,
                          color: Colors.blue,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          'New student #${widget.index + 1}',
                          style: Theme.of(context).textTheme.headlineSmall,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    CustomTextField(
                        isValidated: (isValid) {
                          _updateValidator(name: 'name', isValidated: isValid);
                        },
                        name: 'name',
                        hintText: 'Name'),
                    Column(
                      children: dropDowns,
                    ),
                  ],
                ),
              );
            }
          }
          return const LoadingPage();
        });
  }
}
