enum Gender { boy, girl, other}

extension GenderExt on Gender {
  String toText() {
    switch (this) {
      case Gender.boy:
        return 'Boy';
      case Gender.girl:
        return 'Girl';
      case Gender.other:
        return 'Other';
    }
  }
}
