part of 'settings_form_cubit.dart';

abstract class SettingsFormState extends Equatable {
  const SettingsFormState(this.settingsData);

  final SettingsData settingsData;

  @override
  List<Object> get props => [settingsData];
}

class SettingsFormInitial extends SettingsFormState {
  const SettingsFormInitial(SettingsData settingsData) : super(settingsData);
}

class SettingsFormChanged extends SettingsFormState {
  const SettingsFormChanged(SettingsData settingsData) : super(settingsData);
}

class SettingsFormSaved extends SettingsFormState {
  const SettingsFormSaved(SettingsData settingsData) : super(settingsData);
}
