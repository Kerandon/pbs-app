import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pbs_app/configs/constants.dart';
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
  late final List<CustomDropDown> dropDowns;


  final Map<String, bool> _validatorTracker = {};

  _updateValidator({required String name, required bool isValidated}){
    _validatorTracker.addAll({name : isValidated});

    if(_validatorTracker.entries.every((element) => element.value)){
      widget.isValidated?.call(true);
    }else{
      widget.isValidated?.call(false);
    }
  }

  @override
  void initState() {
    dropDowns = [
      CustomDropDown(
        name: kGender,
        hintText: 'Gender',
        values: Gender.values.map((e) => e.toText()).toList(),
        isValidated: (isValid){
          _updateValidator(name: kGender, isValidated: isValid);
        },
      ),
      CustomDropDown(name: kHouse,
          hintText: 'House',
          values: houses,
        isValidated: (isValid){
          _updateValidator(name: kHouse, isValidated: isValid);
        },
      ),
    ];
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _validatorTracker.addAll({kName : false, kGender : false, kHouse : false});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.person, color: Colors.blue,),
            const SizedBox(width: 8,),
            Text('New student #${widget.index + 1}', style: Theme.of(context).textTheme.headlineSmall,)
          ],),
          const SizedBox(height: 2,),
          CustomTextField(
            isValid: (isValid){
              _updateValidator(name: 'name', isValidated: isValid);
            },
              name: 'name',
              hintText:
                  'Name'),
          Column(
            children: dropDowns,
          ),
        ],
      ),
    );
  }
}
