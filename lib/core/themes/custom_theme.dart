import 'package:flutter/material.dart';

class CustomTheme {
  static Map<String, ThemeData> themes = {
    'light': lightTheme(),
    'dark': darkTheme()
  };
  static ThemeData lightTheme() {
    return ThemeData.light().copyWith(
      primaryColor: const Color(0xffff7043),
      primaryColorLight: const Color(0xffffa270),
      primaryColorDark: const Color(0xffc63f17),
      colorScheme: ThemeData.light().colorScheme.copyWith(
            primary: const Color(0xffff7043),
            primaryVariant: const Color(0xff892c10),
            secondary: const Color(0xff64b5f6),
            secondaryVariant: const Color(0xff2696f2),
            background: const Color(0xffEEE9DE),
          ),
      backgroundColor: const Color(0xffEEEEEE),
      scaffoldBackgroundColor: const Color(0xffEEEEEE),
      textTheme: const TextTheme().copyWith(
        bodyText1: const TextStyle().copyWith(color: Colors.black87),
        bodyText2: const TextStyle().copyWith(color: Colors.black87),
        button: const TextStyle().copyWith(color: Colors.black87),
        subtitle1: const TextStyle()
            .copyWith(color: Colors.black54, fontWeight: FontWeight.bold),
        subtitle2: const TextStyle()
            .copyWith(color: Colors.black54, fontWeight: FontWeight.bold),
        headline1: const TextStyle().copyWith(color: Colors.black54),
        headline2: const TextStyle().copyWith(color: Colors.black54),
        headline3: const TextStyle().copyWith(color: Colors.black54),
        headline4: const TextStyle().copyWith(color: Colors.black54),
        headline5: const TextStyle().copyWith(color: Colors.black54),
        headline6: const TextStyle().copyWith(color: Colors.black54),
      ),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData.dark().copyWith(
      primaryColor: const Color(0xff79250d),
      primaryColorLight: const Color(0xff922c0f),
      primaryColorDark: const Color(0xff5e1c09),
      colorScheme: ThemeData.dark().colorScheme.copyWith(
            primary: const Color(0xff79250d),
            primaryVariant: const Color(0xffa03113),
            secondary: const Color(0xff305776),
            secondaryVariant: const Color(0xff305776),
            background: const Color(0xff4378a3),
          ),
      backgroundColor: const Color(0xff222222),
      scaffoldBackgroundColor: const Color(0xff222222),
      textTheme: const TextTheme().copyWith(
        bodyText1: const TextStyle().copyWith(color: Colors.white60),
        bodyText2: const TextStyle().copyWith(color: Colors.white60),
        button: const TextStyle().copyWith(color: Colors.white60),
        subtitle1: const TextStyle()
            .copyWith(color: Colors.white70, fontWeight: FontWeight.bold),
        subtitle2: const TextStyle()
            .copyWith(color: Colors.white70, fontWeight: FontWeight.bold),
        headline1: const TextStyle().copyWith(color: Colors.white54),
        headline2: const TextStyle().copyWith(color: Colors.white54),
        headline3: const TextStyle().copyWith(color: Colors.white54),
        headline4: const TextStyle().copyWith(color: Colors.white54),
        headline5: const TextStyle().copyWith(color: Colors.white54),
        headline6: const TextStyle().copyWith(color: Colors.white54),
      ),
    );
  }
}
