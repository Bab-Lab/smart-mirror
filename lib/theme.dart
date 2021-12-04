import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData darkTheme = ThemeData.from(
    colorScheme: ColorScheme.dark(
      primary: Colors.grey,
      onPrimary: Colors.blueGrey,
      primaryVariant: Colors.black,
      background: Colors.black,
      secondary: Colors.red,
    ),
    textTheme: Typography.whiteMountainView,
  );
}