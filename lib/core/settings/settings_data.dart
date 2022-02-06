import 'package:flutter/material.dart';

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
