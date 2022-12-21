import 'package:flutter/material.dart';

final appTheme = ThemeData(
  textTheme: TextTheme(displaySmall: appTextStyle()),
  dividerColor: Colors.blue,
);

TextStyle appTextStyle() {
  return const TextStyle(
    fontSize: 10,
    color: Colors.black,
  );
}
