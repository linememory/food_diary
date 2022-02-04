import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsData {
  final String language;
  final ThemeMode themeMode;

  SettingsData({
    this.language = 'en',
    this.themeMode = ThemeMode.system,
  });

  SettingsData copyWith({
    String? language,
    ThemeMode? themeMode,
  }) {
    return SettingsData(
      language: language ?? this.language,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  static Future<SettingsData> load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ThemeMode themeModeFromString(String mode) => mode == 'light'
        ? ThemeMode.light
        : mode == 'dark'
            ? ThemeMode.dark
            : ThemeMode.system;
    return SettingsData(
        language: prefs.getString('language') ?? 'en',
        themeMode: themeModeFromString(prefs.getString('theme_mode') ?? ''));
  }

  Future save() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String themeModeToString(ThemeMode themeMode) =>
        themeMode == ThemeMode.light
            ? 'light'
            : themeMode == ThemeMode.dark
                ? 'dark'
                : 'system';
    prefs.setString('theme_mode', themeModeToString(themeMode));
    prefs.setString('language', language);
  }

  @override
  String toString() => 'SettingsData(locale: $language, themeMode: $themeMode)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SettingsData &&
        other.language == language &&
        other.themeMode == themeMode;
  }

  @override
  int get hashCode => language.hashCode ^ themeMode.hashCode;
}
