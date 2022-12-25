import 'package:flutter/material.dart';

final appTheme = ThemeData(
  textTheme: TextTheme(
      headlineSmall: appTextStyle().copyWith(fontStyle: FontStyle.italic, color: Colors.grey),
      displaySmall: appTextStyle()),
  dividerColor: Colors.blue,

    outlinedButtonTheme: OutlinedButtonThemeData(

style: OutlinedButton.styleFrom(
  textStyle: appTextStyle().copyWith(fontSize: 12)
)

),

  appBarTheme: AppBarTheme(
    elevation: 0,
    titleTextStyle: appTextStyle().copyWith(color: Colors.white)
  )

);

TextStyle appTextStyle() {
  return const TextStyle(
    fontSize: 15,
    color: Colors.black,
  );
}
