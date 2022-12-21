// import 'package:flutter/material.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:pbs_app/data/houses.dart';
// import 'package:pbs_app/form_provider.dart';
// import 'package:pbs_app/models/form_value.dart';
// import 'package:pbs_app/utils/enums/gender.dart';
//
// class CustomForm extends ConsumerStatefulWidget {
//   const CustomForm({Key? key}) : super(key: key);
//
//   @override
//   ConsumerState<CustomForm> createState() => _CustomFormState();
// }
//
// class _CustomFormState extends ConsumerState<CustomForm> {
//   List<GlobalObjectKey<FormBuilderState>> _formKeys = [];
//
//   @override
//   void initState() {
//     for (int i = 0; i < 2; i++) {
//       _formKeys.add(GlobalObjectKey<FormBuilderState>(i));
//     }
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       ref.read(formProvider.notifier).setTotalFields(4);
//     });
//
//     if (ref.read(formProvider).haveCheckedAllFields) {
//       if (ref.watch(formProvider).validate) {
//         for (var element in _formKeys) {
//           element.currentState!.validate();
//         }
//       }
//     }
//
//     if (ref.watch(formProvider).validate) {
//       if (_formKeys.every((element) => element.currentState!.validate())) {
//         for (var k in _formKeys) {
//           k.currentState!.save();
//           final value = k.currentState!.value.values;
//           for(var v in value){
//             print(v);
//           }
//         }
//       }
//     }
//
//     return Scaffold(
//       appBar: AppBar(),
//       body: ListView.builder(
//         itemCount: 2,
//         itemBuilder: (context, index) => CustomStudentForm(
//           formKey: _formKeys[index],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           ref
//               .read(formProvider.notifier)
//               .validateForms(validate: true, checkAllFields: true);
//         },
//       ),
//     );
//   }
// }
//
// class CustomStudentForm extends ConsumerStatefulWidget {
//   const CustomStudentForm({required this.formKey, Key? key}) : super(key: key);
//
//   final GlobalObjectKey<FormBuilderState> formKey;
//
//   @override
//   ConsumerState<CustomStudentForm> createState() => _CustomStudentFormState();
// }
//
// class _CustomStudentFormState extends ConsumerState<CustomStudentForm> {
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: FormBuilder(
//         key: widget.formKey,
//         child: Column(
//           children: [
//             CustomTextFormField(
//                 name: 'Name',
//                 fieldId: {widget.formKey.value as int : 'name'}),
//             CustomDropDownNew(
//               name: 'Houses',
//               items: houses,
//               fieldId: {widget.formKey.value as int: 'houses'},
//             ),
//             CustomDropDownNew(
//               name: 'Gender',
//               items: Gender.values.map((e) => e.toText()).toList(),
//               fieldId: {widget.formKey.value as int: 'fruit'},
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class CustomTextFormField extends ConsumerStatefulWidget {
//   const CustomTextFormField({required this.name, required this.fieldId,
//     super.key,
//   });
//
//   final String name;
//   final Map<int, dynamic> fieldId;
//
//
//   @override
//   ConsumerState<CustomTextFormField> createState() => _CustomTextFormFieldState();
// }
//
// class _CustomTextFormFieldState extends ConsumerState<CustomTextFormField> {
//   bool _dataSubmitted = false;
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       validator: (value){
//         if(value == null || value.isEmpty){
//           return 'Field is blank';
//         }
//         return null;
//       },
//       initialValue: '', style: Theme.of(context).textTheme.displaySmall!.copyWith(
//       color: Colors.black54
//     ),
//       onSaved: (value) {
//         if (!_dataSubmitted) {
//           WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//             print('submit data!');
//             ref.read(formProvider.notifier).setValues(
//                 value: FormValue(fieldID: widget.fieldId, value: value));
//           });
//           _dataSubmitted = true;
//           setState(() {});
//         }
//       },
//     );
//
//   }
// }
//
// class CustomDropDownNew extends ConsumerStatefulWidget {
//   const CustomDropDownNew({
//     required this.fieldId,
//     required this.items,
//     required this.name,
//     Key? key,
//   }) : super(key: key);
//
//   final List<String> items;
//   final String name;
//   final Map<int, dynamic> fieldId;
//
//   @override
//   ConsumerState<CustomDropDownNew> createState() => _CustomDropDownNewState();
// }
//
// class _CustomDropDownNewState extends ConsumerState<CustomDropDownNew> {
//   final List<DropdownMenuItem<String>> _items = [];
//
//   String? _selectedValue;
//   bool _dataSubmitted = false;
//
//   @override
//   void initState() {
//     for (var i in widget.items) {
//       _items.add(
//         DropdownMenuItem(value: i, child: Text(i)),
//       );
//     }
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return DropdownButtonFormField(
//       value: _selectedValue,
//       hint: Text(widget.name, style: Theme.of(context).textTheme.displaySmall!.copyWith(
//         color: Colors.black54,)),
//       items: _items,
//       onChanged: (value) {
//         if (ref.read(formProvider).haveCheckedAllFields) {
//           ref.read(formProvider.notifier).validateForms(validate: true);
//           _selectedValue = value!;
//           setState(() {});
//         }
//       },
//       validator: (value) {
//         if (value == null) {
//           return 'No options selected';
//         }
//         return null;
//       },
//       onSaved: (value) {
//         if (!_dataSubmitted) {
//           WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//             print('submit data!');
//             ref.read(formProvider.notifier).setValues(
//                 value: FormValue(fieldID: widget.fieldId, value: value));
//           });
//           _dataSubmitted = true;
//           setState(() {});
//         }
//       },
//     );
//   }
// }
