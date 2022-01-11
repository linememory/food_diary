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
          ),
      backgroundColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
    );
  }

  static ThemeData darkTheme() {
    return ThemeData.dark().copyWith(
        primaryColor: const Color(0xff202020),
        primaryColorLight: const Color(0xff303030),
        primaryColorDark: const Color(0xff101010),
        colorScheme: ThemeData.dark().colorScheme.copyWith(
              secondary: const Color(0xffc63f17),
            ),
        backgroundColor: Colors.grey,
        scaffoldBackgroundColor: Colors.black54
        //textTheme: TextTheme()
        );
  }
}
