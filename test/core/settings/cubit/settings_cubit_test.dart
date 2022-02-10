import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_diary/core/settings/cubit/settings_cubit.dart';
import 'package:food_diary/core/settings/settings_data.dart';
import 'package:food_diary/core/settings/settings_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  late MockSettingsRepository mockSettingsRepository;
  SettingsData settingsData =
      SettingsData(language: 'en', themeMode: ThemeMode.system);

  setUp(() {
    mockSettingsRepository = MockSettingsRepository();
    when(() => mockSettingsRepository.load()).thenAnswer(
        (_) => SettingsData(language: 'en', themeMode: ThemeMode.system));
  });

  blocTest(
    "emits [SettingsChanged()] when settingsChanged is called.",
    build: () => SettingsCubit(mockSettingsRepository),
    act: (SettingsCubit bloc) =>
        bloc.settingsChanged(settingsData.copyWith(language: 'de')),
    expect: () =>
        <SettingsState>[SettingsChanged(settingsData.copyWith(language: 'de'))],
  );

  // blocTest(
  //   "emits [SettingsChanged()] when loadSettings is called.",
  //   build: () => SettingsCubit(mockSettingsRepository),
  //   act: (SettingsCubit bloc) => bloc.loadSettings(),
  //   verify: (bloc) => verify(() => mockSettingsRepository.load()),
  //   expect: () => <SettingsState>[SettingsChanged(settingsData)],
  // );
}
