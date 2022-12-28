import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pbs_app/forms/custom_text_field.dart';
import 'package:pbs_app/utils/enums/form_types.dart';
import 'package:pbs_app/forms/student_form.dart';
import 'package:pbs_app/utils/methods/methods_forms.dart';

class FormMain extends ConsumerStatefulWidget {
  const FormMain({
    Key? key,
    required this.formType,
    required this.title,
    required this.onExitPage,
  }) : super(key: key);

  final FormType formType;
  final String title;
  final VoidCallback onExitPage;

  @override
  ConsumerState<FormMain> createState() => _FormMainState();
}

class _FormMainState extends ConsumerState<FormMain> {
  final List<GlobalKey<FormBuilderState>> _formKeys = [];

  int _numberOfForms = 0;
  bool _allFormsValidated = false;
  final Map<int, bool> _validatorTracker = {};

  _addFormToValidatorTracker({required int index, required bool isValidated}) {
    _validatorTracker.addAll({index: isValidated});
    _checkIfAllFormsAreValidated();
  }

  _removeFromFromValidatorTracker() {
    _validatorTracker.removeWhere((key, value) => key == _numberOfForms);
    _checkIfAllFormsAreValidated();
  }

  _checkIfAllFormsAreValidated() {
    if (_validatorTracker.entries.every((element) => element.value)) {
      _allFormsValidated = true;
    } else {
      _allFormsValidated = false;
    }
    setState(() {});
  }

  @override
  initState() {
    _addForm();
    super.initState();
  }

  _addForm() {
    _numberOfForms++;
    _formKeys.add(GlobalKey<FormBuilderState>());
    _addFormToValidatorTracker(index: _numberOfForms - 1, isValidated: false);
  }

  _removeForm() {
    if (_formKeys.length > 1) {
      _numberOfForms--;
      _formKeys.removeLast();
      _removeFromFromValidatorTracker();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: widget.onExitPage,
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(widget.title),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: size.width * 0.05),
            child: Center(
                child: Text(
              _numberOfForms.toString(),
              style: Theme.of(context).textTheme.headlineMedium,
            )),
          ),
          IconButton(
            onPressed: () {
              _addForm();
            },
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () {
              _removeForm();
            },
            icon: const Icon(Icons.remove),
          ),
        ],
      ),
      body: ListView.builder(
          padding: EdgeInsets.only(
              top: 28, left: size.width * 0.09, right: size.width * 0.09),
          itemCount: _numberOfForms + 1,
          itemBuilder: (context, index) {
            if (index < _numberOfForms) {
              if (widget.formType == FormType.student) {
                return Column(
                  children: [
                    StudentForm(
                      index: index,
                      formKey: _formKeys[index],
                      isValidated: (isValidated) {
                        _addFormToValidatorTracker(
                            index: index, isValidated: isValidated);
                      },
                    ),
                    SizedBox(
                      height: size.height * 0.05,
                    )
                  ],
                );
              } else if (widget.formType == FormType.classroom) {
                return FormBuilder(
                  key: _formKeys[index],
                  child: CustomTextField(
                    name: 'class $_numberOfForms',
                    hintText: 'Classroom #${index + 1}',
                    isValidated: (isValidated) {
                      _addFormToValidatorTracker(
                          index: index, isValidated: isValidated);
                    },
                  ),
                );
              }
              return null;
            }
            if (index == _numberOfForms) {
              return OutlinedButton(
                onPressed: _numberOfForms > 0 && _allFormsValidated
                    ? () {
                        if (_formKeys.isNotEmpty) {
                          for (var w in _formKeys) {
                            w.currentState!.saveAndValidate();
                          }
                          if (widget.formType == FormType.classroom) {
                            formSubmittedClassrooms(
                                context: context,
                                formKeys: _formKeys,
                                ref: ref);
                          }
                          if (widget.formType == FormType.student) {
                            formSubmittedStudents(
                                context: context,
                                ref: ref,
                                formKeys: _formKeys);
                          }
                        }
                      }
                    : null,
                child: const Text('Submit'),
              );
            }
            return null;
          }),
    );
  }
}
