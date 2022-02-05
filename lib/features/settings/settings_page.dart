import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_diary/core/settings/cubit/settings_cubit.dart';
import 'package:food_diary/features/settings/cubit/settings_form_cubit.dart';
import 'package:food_diary/generated/l10n.dart';
import 'package:food_diary/injection_container.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SettingsFormCubit(BlocProvider.of<SettingsCubit>(context), sl()),
      child: Builder(builder: (context) {
        return BlocListener<SettingsFormCubit, SettingsFormState>(
          listener: (context, state) {
            if (state is SettingsFormSaved) {
              Navigator.pop(context);
            }
          },
          child: Scaffold(
            appBar: AppBar(
              //toolbarHeight: 0,
              title: Text(AppLocalization.current.settings),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Settings(),
                FormButtons(
                  onSave: () {
                    BlocProvider.of<SettingsFormCubit>(context).saveSettings();
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Expanded(
        child: SingleChildScrollView(
          child: BlocBuilder<SettingsFormCubit, SettingsFormState>(
            builder: (context, state) {
              return Column(
                children: [
                  SettingsRow(
                    label: AppLocalization.current.settingsFormLanguagesLabel,
                    setting: DropdownButton<String>(
                      value: state.settingsData.language,
                      items: [
                        DropdownMenuItem(
                            value: 'en',
                            child:
                                Text(AppLocalization.current.languageEnglish)),
                        DropdownMenuItem(
                            value: 'de',
                            child:
                                Text(AppLocalization.current.languageGerman)),
                      ],
                      onChanged: (value) {
                        BlocProvider.of<SettingsFormCubit>(context)
                            .languageChanged(value);
                      },
                    ),
                  ),
                  SettingsRow(
                    label: AppLocalization.current.settingsFormThemesLabel,
                    setting: DropdownButton<ThemeMode>(
                      value: state.settingsData.themeMode,
                      items: [
                        DropdownMenuItem(
                            value: ThemeMode.system,
                            child:
                                Text(AppLocalization.current.themeModeSystem)),
                        DropdownMenuItem(
                            value: ThemeMode.light,
                            child:
                                Text(AppLocalization.current.themeModeLight)),
                        DropdownMenuItem(
                            value: ThemeMode.dark,
                            child: Text(AppLocalization.current.themeModeDark))
                      ],
                      onChanged: (value) {
                        BlocProvider.of<SettingsFormCubit>(context)
                            .themeChanged(value);
                      },
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class SettingsRow extends StatelessWidget {
  const SettingsRow({Key? key, required this.label, required this.setting})
      : super(key: key);
  final String label;
  final Widget setting;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(label), setting],
        ),
        const Divider(
          height: 3,
          thickness: 1,
        )
      ],
    );
  }
}

class FormButtons extends StatelessWidget {
  const FormButtons({Key? key, required this.onSave}) : super(key: key);

  final void Function() onSave;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalization.current.settingsFormCancel),
            ),
            ElevatedButton(
              onPressed: onSave,
              child: Text(AppLocalization.current.settingsFormSave),
            ),
          ],
        ),
      ],
    );
  }
}
