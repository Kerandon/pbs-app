import 'package:flutter/material.dart';

final appTheme = ThemeData(
  textTheme: TextTheme(
    displaySmall: appTextStyle()
  )
);

TextStyle appTextStyle() {
  return const TextStyle(
    fontSize: 12,
    color: Colors.black,
  );
}