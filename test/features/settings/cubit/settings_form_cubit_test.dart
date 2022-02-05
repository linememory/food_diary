import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_diary/core/settings/cubit/settings_cubit.dart';
import 'package:food_diary/core/settings/settings_data.dart';
import 'package:food_diary/core/settings/settings_repository.dart';
import 'package:food_diary/features/settings/cubit/settings_form_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

class MockSettingsCubit extends Mock implements SettingsCubit {}

void main() {
  late MockSettingsRepository mockSettingsRepository;
  late MockSettingsCubit mockSettingsCubit;
  SettingsData settingsData =
      SettingsData(language: 'en', themeMode: ThemeMode.system);

  setUp(() {
    mockSettingsRepository = MockSettingsRepository();
    mockSettingsCubit = MockSettingsCubit();
    registerFallbackValue(settingsData);
    when(() => mockSettingsRepository.load()).thenAnswer(
        (_) => SettingsData(language: 'en', themeMode: ThemeMode.system));
    when(() => mockSettingsRepository.save(any()))
        .thenAnswer((_) async => true);
  });

  // blocTest(
  //   "emits [SettingsFormChanged()] when loadSettings is called.",
  //   build: () => SettingsFormCubit(mockSettingsCubit, mockSettingsRepository),
  //   act: (SettingsFormCubit bloc) => bloc.loadSettings(),
  //   verify: (_) => verify(()=>mockSettingsRepository.load()),
  //   expect: () => <SettingsFormState>[SettingsFormChanged(settingsData)],
  // );

  blocTest(
    "emits [SettingsFormChanged()] when languageChanged is called.",
    build: () => SettingsFormCubit(mockSettingsCubit, mockSettingsRepository),
    act: (SettingsFormCubit bloc) => bloc.languageChanged('de'),
    expect: () => <SettingsFormState>[
      SettingsFormChanged(settingsData.copyWith(language: 'de'))
    ],
  );

  blocTest(
    "emits [SettingsFormChanged()] when themeChanged is called.",
    build: () => SettingsFormCubit(mockSettingsCubit, mockSettingsRepository),
    act: (SettingsFormCubit bloc) => bloc.themeChanged(ThemeMode.light),
    expect: () => <SettingsFormState>[
      SettingsFormChanged(settingsData.copyWith(themeMode: ThemeMode.light))
    ],
  );

  blocTest(
    "emits [SettingsFormSaved()] when saveSettings is called.",
    build: () => SettingsFormCubit(mockSettingsCubit, mockSettingsRepository),
    act: (SettingsFormCubit bloc) async => await bloc.saveSettings(),
    verify: (bloc) {
      verify(() => mockSettingsRepository.save(settingsData));
      verify(() => mockSettingsCubit.settingsChanged(settingsData));
    },
    expect: () => <SettingsFormState>[SettingsFormSaved(settingsData)],
  );
}
