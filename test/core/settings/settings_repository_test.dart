import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_diary/core/settings/settings_data.dart';
import 'package:food_diary/core/settings/settings_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late SettingsRepository settingsRepository;

  late MockSharedPreferences mockSharedPreferences;
  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    settingsRepository = SettingsRepository(mockSharedPreferences);
  });

  SettingsData settingsData =
      SettingsData(language: "en", themeMode: ThemeMode.system);
  group("settings reposity", () {
    test('should return SettingsData', () {
      // arrange
      when(() => mockSharedPreferences.getString('language')).thenReturn("en");
      when(() => mockSharedPreferences.getString('theme_mode'))
          .thenReturn("system");
      // act
      SettingsData settingsData = settingsRepository.load();
      // assert
      verify(() => mockSharedPreferences.getString('language'));
      verify(() => mockSharedPreferences.getString('theme_mode'));
      expect(settingsData, equals(settingsData));
    });

    test('should call setString with language and theme_mode', () async {
      // arrange
      when(() => mockSharedPreferences.setString(any(), any()))
          .thenAnswer((_) async => true);
      // act
      bool result = await settingsRepository.save(settingsData);
      // assert
      verify(() => mockSharedPreferences.setString('language', any()));
      verify(() => mockSharedPreferences.setString('theme_mode', any()));
      expect(result, equals(true));
    });
  });
}
