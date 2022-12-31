import 'package:flutter/material.dart';
import 'package:pbs_app/configs/ui_constants.dart';

final appTheme = ThemeData(
  textTheme: TextTheme(
      headlineSmall: appTextStyle()
          .copyWith(fontStyle: FontStyle.italic, color: Colors.grey),
      headlineMedium:
          appTextStyle().copyWith(color: Colors.white, fontSize: 16),
      displaySmall: appTextStyle()),
  dividerColor: Colors.blue,
  outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
          textStyle: appTextStyle().copyWith(fontSize: 12))),
  appBarTheme: AppBarTheme(
    elevation: 0,
    titleTextStyle: appTextStyle().copyWith(color: Colors.white),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(kBorderRadius),
        bottomRight: Radius.circular(kBorderRadius),
      ),
    ),
  ),
);

TextStyle appTextStyle() {
  return const TextStyle(
    fontSize: 12,
    color: Colors.black,
  );
}
