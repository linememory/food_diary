import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsData {
  final String locale;
  final ThemeMode themeMode;

  SettingsData({
    this.locale = 'en',
    this.themeMode = ThemeMode.system,
  });

  SettingsData copyWith({
    String? locale,
    ThemeMode? themeMode,
  }) {
    return SettingsData(
      locale: locale ?? this.locale,
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
        locale: prefs.getString('locale') ?? 'en',
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
    prefs.setString('locale', locale);
  }

  @override
  String toString() => 'SettingsData(locale: $locale, themeMode: $themeMode)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SettingsData &&
        other.locale == locale &&
        other.themeMode == themeMode;
  }

  @override
  int get hashCode => locale.hashCode ^ themeMode.hashCode;
}
