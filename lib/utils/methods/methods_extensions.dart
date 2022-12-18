extension Capitalize on String {
  String capitalizeFirstLetter() {
    final firstLetter = this[0].toUpperCase();
    return firstLetter + substring(1);
  }
}
