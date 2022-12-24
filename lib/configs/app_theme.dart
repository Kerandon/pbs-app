import 'package:flutter/material.dart';

final appTheme = ThemeData(
  textTheme: TextTheme(displaySmall: appTextStyle()),
  dividerColor: Colors.blue,
);

TextStyle appTextStyle() {
  return const TextStyle(
    fontSize: 15,
    color: Colors.black,
  );
}
