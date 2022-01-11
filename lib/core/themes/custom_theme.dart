import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData lightTheme() {
    return ThemeData.light().copyWith(
      primaryColor: const Color(0xffff7043),
      primaryColorLight: const Color(0xffffa270),
      primaryColorDark: const Color(0xffc63f17),
      colorScheme: ThemeData.light().colorScheme.copyWith(
            secondary: const Color(0xff64b5f6),
            primary: const Color(0xffc63f17),
            background: const Color(0xffEEE9DE),
          ),
      backgroundColor: const Color(0xffEEEEEE),
      scaffoldBackgroundColor: const Color(0xffEEEEEE),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData.dark().copyWith(
      primaryColor: const Color(0xff79250d),
      primaryColorLight: const Color(0xff922c0f),
      primaryColorDark: const Color(0xff5e1c09),
      colorScheme: ThemeData.dark().colorScheme.copyWith(
            secondary: const Color(0xff305776),
            primary: const Color(0xff601e0b),
            background: const Color(0xff262523),
          ),
      backgroundColor: const Color(0xff222222),
      scaffoldBackgroundColor: const Color(0xff222222),
      //textTheme: TextTheme()
    );
  }
}
