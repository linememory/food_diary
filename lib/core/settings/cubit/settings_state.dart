part of 'settings_cubit.dart';

abstract class SettingsState extends Equatable {
  const SettingsState(this.settingsData);

  final SettingsData settingsData;

  @override
  List<Object> get props => [settingsData];
}

class SettingsInitial extends SettingsState {
  const SettingsInitial(SettingsData settingsData) : super(settingsData);
}

class SettingsChanged extends SettingsState {
  const SettingsChanged(SettingsData settingsData) : super(settingsData);
}
