// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:pbs_app/models/form_value.dart';
// import 'package:pbs_app/utils/methods/methods_forms.dart';
//
// class FormStateObject {
//   final int totalFields;
//   final bool validate;
//   final bool haveCheckedAllFields;
//   final Set<FormValue> formValues;
//   final bool successfullySubmitted;
//
//   FormStateObject({
//     required this.totalFields,
//     required this.validate,
//     required this.formValues,
//     required this.haveCheckedAllFields,
//     required this.successfullySubmitted,
//   });
//
//   FormStateObject copyWith({
//     int? totalFields,
//     bool? validate,
//     Set<FormValue>? formValues,
//     bool? haveCheckedAllFields,
//     bool? successfullySubmitted,
//   }) {
//     return FormStateObject(
//         totalFields: totalFields ?? this.totalFields,
//         validate: validate ?? this.validate,
//         formValues: formValues ?? this.formValues,
//         haveCheckedAllFields: haveCheckedAllFields ?? this.haveCheckedAllFields,
//         successfullySubmitted:
//             successfullySubmitted ?? this.successfullySubmitted);
//   }
// }
//
// class FormNotifier extends StateNotifier<FormStateObject> {
//   FormNotifier(FormStateObject state) : super(state);
//
//   void setTotalFields(int total) {
//     state = state.copyWith(totalFields: total);
//   }
//
//   void validateForms({required bool validate, bool? checkAllFields}) {
//     state = state.copyWith(
//         validate: validate, haveCheckedAllFields: checkAllFields);
//   }
//
//   void setValues({required FormValue value}) {
//
//     print('submit data !!! ${value.fieldID} ${value.value}');
//
//     state = state.copyWith(formValues: {...state.formValues, value});
//
//
//
//     if (state.formValues.length == state.totalFields) {
//       for (var d in state.formValues) {
//         print('--values submitted ${d.fieldID} ${d.value}');
//         getStudentsFromFormNew(formValues: state.formValues);
//       }
//     }
//   }
// }
//
// final formProvider = StateNotifierProvider<FormNotifier, FormStateObject>(
//   (ref) => FormNotifier(
//     FormStateObject(
//       totalFields: 0,
//       validate: false,
//       haveCheckedAllFields: false,
//       formValues: {},
//       successfullySubmitted: false,
//     ),
//   ),
// );
