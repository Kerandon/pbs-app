import 'package:equatable/equatable.dart';

class FormValue extends Equatable {
  final Map<int, dynamic> fieldID;
  final dynamic value;

  const FormValue({required this.fieldID, required this.value});

  @override
  List<Object> get props => [fieldID];
}
