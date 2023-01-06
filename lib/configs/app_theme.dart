import 'package:flutter/material.dart';
import 'package:pbs_app/configs/ui_constants.dart';

import 'app_colors.dart';

final appTheme = ThemeData(
  primaryColor: AppColors.greenlandGreen,
  primaryColorDark: AppColors.deepCove,
  secondaryHeaderColor: AppColors.hintOfIce,
  textTheme: TextTheme(
      headlineSmall: appTextStyle()
          .copyWith(fontSize: 16, color: Colors.white),
      headlineMedium:
          appTextStyle().copyWith(color: Colors.white, fontSize: 20),
      displaySmall: appTextStyle().copyWith(color: Colors.black, fontSize: 12)),
  dividerColor: AppColors.lightGrey,
  outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
          textStyle: appTextStyle().copyWith(fontSize: 12, color: Colors.black),),),
  appBarTheme: AppBarTheme(
    color: AppColors.greenlandGreen,
    elevation: 0,
    titleTextStyle: appTextStyle().copyWith(color: Colors.white),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(kBorderRadius),
        bottomRight: Radius.circular(kBorderRadius),
      ),
    ),
  ),
  dialogTheme: DialogTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(kBorderRadius)
    )
  ),
  iconTheme: const IconThemeData(color: Colors.grey, size: 16)
);

TextStyle appTextStyle() {
  return const TextStyle(
    fontSize: 16,
    color: Colors.black,
  );
}
