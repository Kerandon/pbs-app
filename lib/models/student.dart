import '../utils/enums/gender.dart';

class Student {
  final String name;
  final Gender gender;
  final String house;
  final String classRoom;

  Student(
      {required this.name,
      required this.gender,
      required this.house,
      required this.classRoom});

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
    return Student(name: name, gender: g, house: house, classRoom: classRoom);
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
      classRoom: json['classroom'],
    );
  }
}
