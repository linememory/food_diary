import 'package:flutter/material.dart';

class CustomTheme {
  static Map<String, ThemeData> themes = {
    'light': lightTheme(),
    'dark': darkTheme()
  };
  static ThemeData lightTheme() {
    return ThemeData.light().copyWith(
      primaryColor: Color.fromARGB(255, 245, 93, 82),
      colorScheme: ThemeData.light().colorScheme.copyWith(
            primary: Color.fromARGB(255, 245, 93, 82),
            secondary: Color.fromARGB(255, 236, 236, 236),
            background: Color.fromARGB(255, 255, 255, 255),
          ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      scaffoldBackgroundColor: Color.fromARGB(255, 255, 255, 255),
      textTheme: const TextTheme().copyWith(
        bodyText1: const TextStyle().copyWith(color: Colors.black),
        bodyText2: const TextStyle().copyWith(color: Colors.black),
        button: const TextStyle().copyWith(color: Colors.black),
        subtitle1: const TextStyle()
            .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
        subtitle2: const TextStyle()
            .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
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
      primaryColor: Color.fromARGB(255, 121, 38, 38),
      colorScheme: ThemeData.dark().colorScheme.copyWith(
            primary: Color.fromARGB(255, 121, 38, 38),
            secondary: Color.fromARGB(255, 43, 43, 43),
            background: Color.fromARGB(255, 26, 26, 26),
          ),
      backgroundColor: const Color.fromARGB(255, 26, 26, 26),
      scaffoldBackgroundColor: Color.fromARGB(255, 26, 26, 26),
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
