enum Gender { male, female, other }

extension GenderExt on Gender {
  String toText() {
    switch (this) {
      case Gender.male:
        return 'Male';
      case Gender.female:
        return 'Female';
      case Gender.other:
        return 'Other';
    }
  }
}
