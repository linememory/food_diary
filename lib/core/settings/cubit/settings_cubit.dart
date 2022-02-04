import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:food_diary/core/settings/settings_data.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit()
      : super(SettingsInitial(
            SettingsData(locale: "en", themeMode: ThemeMode.system))) {
    loadSettings();
  }

  void settingsChanged(SettingsData settingsData) {
    emit(SettingsChanged(settingsData));
  }

  void loadSettings() async {
    emit(SettingsChanged(await SettingsData.load()));
  }
}
