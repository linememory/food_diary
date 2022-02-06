import 'package:flutter/material.dart';
import 'package:food_diary/core/settings/settings_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  SharedPreferences sharedPreferences;

  SettingsRepository(this.sharedPreferences);

  SettingsData load() {
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    ThemeMode themeModeFromString(String mode) => mode == 'light'
        ? ThemeMode.light
        : mode == 'dark'
            ? ThemeMode.dark
            : ThemeMode.system;
    return SettingsData(
        language: sharedPreferences.getString('language') ?? 'en',
        themeMode: themeModeFromString(
            sharedPreferences.getString('theme_mode') ?? ''));
  }

  Future<bool> save(SettingsData settings) async {
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String themeModeToString(ThemeMode themeMode) =>
        themeMode == ThemeMode.light
            ? 'light'
            : themeMode == ThemeMode.dark
                ? 'dark'
                : 'system';
    bool themeModeResult = await sharedPreferences.setString(
        'theme_mode', themeModeToString(settings.themeMode));
    bool languageResult =
        await sharedPreferences.setString('language', settings.language);

    return themeModeResult && languageResult;
  }
}
