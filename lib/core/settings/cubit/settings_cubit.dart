import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:food_diary/core/settings/settings_data.dart';
import 'package:food_diary/core/settings/settings_repository.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepository settingsRepository;
  SettingsCubit(this.settingsRepository)
      : super(SettingsInitial(
            SettingsData(language: "en", themeMode: ThemeMode.system))) {
    loadSettings();
  }

  void settingsChanged(SettingsData settingsData) {
    emit(SettingsChanged(settingsData));
  }

  void loadSettings() {
    emit(SettingsChanged(settingsRepository.load()));
  }
}
