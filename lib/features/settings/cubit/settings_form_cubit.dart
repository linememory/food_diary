import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:food_diary/core/settings/cubit/settings_cubit.dart';
import 'package:food_diary/core/settings/settings_data.dart';

part 'settings_form_state.dart';

class SettingsFormCubit extends Cubit<SettingsFormState> {
  SettingsFormCubit(this.settingsCubit)
      : super(SettingsFormInitial(SettingsData())) {
    loadSettings();
  }

  final SettingsCubit settingsCubit;

  void loadSettings() async {
    emit(SettingsFormChanged(await SettingsData.load()));
  }

  void languageChanged(String? locale) {
    emit(SettingsFormChanged(state.settingsData.copyWith(language: locale)));
  }

  void themeChanged(ThemeMode? themeMode) {
    emit(
        SettingsFormChanged(state.settingsData.copyWith(themeMode: themeMode)));
  }

  Future<void> saveSettings() async {
    await state.settingsData.save();
    settingsCubit.settingsChanged(state.settingsData);
    emit(SettingsFormSaved(state.settingsData));
  }
}
