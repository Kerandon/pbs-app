import 'package:equatable/equatable.dart';

import '../utils/enums/gender.dart';

class Student extends Equatable {
  final String name;
  final Gender gender;
  final String house;
  final String classroom;
  final bool present;
  final int points;

  const Student({
    required this.name,
    required this.gender,
    required this.house,
    required this.classroom,
    required this.present,
    required this.points,
  });

  factory Student.fromForm(
      {required String name,
      required String gender,
      required String house,
      required String classRoom}) {
    Gender g = Gender.male;
    if (gender == Gender.female.name) {
      g = Gender.female;
    }
    if (gender == Gender.other.name) {
      g == Gender.other;
    }
    return Student(
      name: name,
      gender: g,
      house: house,
      classroom: classRoom,
      present: true,
      points: 0,
    );
  }

  factory Student.fromJson(
      {required String name, required Map<String, dynamic> json}) {
    Gender gender = Gender.male;
    String g = json['gender'];
    if (g == Gender.female.name) {
      gender = Gender.female;
    }
    if (g == Gender.other.name) {
      gender == Gender.other;
    }

    return Student(
      name: name,
      gender: gender,
      house: json['house'],
      classroom: json['classroom'],
      present: json['present'],
      points: json['points'],
    );
  }

  @override
  List<Object?> get props => [name];
}
