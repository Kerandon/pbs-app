import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pbs_app/utils/enums/form_types.dart';
import 'package:pbs_app/forms/student_form.dart';

class FormMain extends StatefulWidget {
  const FormMain({Key? key, required this.onSubmit, required this.formType})
      : super(key: key);

  final Function(List<GlobalKey<FormBuilderState>> formKeys) onSubmit;
  final FormType formType;

  @override
  State<FormMain> createState() => _FormMainState();
}

class _FormMainState extends State<FormMain> {
  final List<GlobalKey<FormBuilderState>> _formKeys = [];

  int _numberOfForms = 0;

  @override
  initState() {
    _addForm();
    super.initState();
  }

  _addForm() {
    _numberOfForms++;
    _formKeys.add(GlobalKey<FormBuilderState>());
    setState(() {});
  }

  _removeForm() {
    if (_formKeys.isNotEmpty) {
      _numberOfForms--;
      _formKeys.removeLast();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {

          print('number of forms $_numberOfForms form keys ${_formKeys.length}');

          if (_formKeys.isNotEmpty) {
            bool isValid = _formKeys
                .every((element) => element.currentState!.saveAndValidate());

            for (var w in _formKeys) {
              w.currentState!.saveAndValidate();
            }

            if (isValid) {
              for(var k in _formKeys){
                print(k.currentState!.value);
                print(_formKeys);
              }
              widget.onSubmit(_formKeys);
            }
          }
        },
        child: const Icon(Icons.done),
      ),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              _removeForm();
            },
            icon: const Icon(Icons.remove),
          ),
          IconButton(
            onPressed: () {
              _addForm();
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          size.width * 0.04,
          size.height * 0.02,
          size.width * 0.04,
          size.height * 0.02,
        ),
        child: ListView.builder(
          itemCount: _numberOfForms,
          itemBuilder: (context, index) {
            if (widget.formType == FormType.student) {
              return StudentForm(
                index: index,
                formKey: _formKeys[index],
                removeDivider: index + 1 == _numberOfForms,
              );
            }
            return null;
          },
        ),
      ),
    );
  }
}
