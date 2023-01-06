import 'package:equatable/equatable.dart';

import '../utils/enums/gender.dart';

class Student extends Equatable {
  final String name;
  final Gender gender;
  final String house;
  final String classroom;
  final bool present;
  final int points;
  final bool topPoints;

  const Student({
    required this.name,
    required this.gender,
    required this.house,
    required this.classroom,
    required this.present,
    required this.points,
    required this.topPoints,
  });

  factory Student.fromForm(
      {required String name,
      required String gender,
      required String house,
      required String classRoom}) {
    Gender g = Gender.boy;
    if (gender == Gender.girl.name) {
      g = Gender.girl;
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
      topPoints: false,
    );
  }



  factory Student.fromJson(
      {required String name, required Map<String, dynamic> json}) {
    Gender gender = Gender.boy;
    String g = json['gender'];
    if (g == Gender.girl.name) {
      gender = Gender.girl;
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
      topPoints: json['topPoints']
    );
  }

  factory Student.emptyInitialize(){
    return const Student(name: "", gender: Gender.boy, house: "", classroom: "", present: true, points: 0, topPoints: false);
  }

  @override
  List<Object?> get props => [name];
}
