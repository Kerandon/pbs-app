import 'package:equatable/equatable.dart';

class Note extends Equatable {
  final int index;
  final String note;
  final String date;

  const Note({required this.note, required this.index, required this.date});

  @override
  List<Object?> get props => [index];
}
