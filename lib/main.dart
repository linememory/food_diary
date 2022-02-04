import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_diary/core/settings/cubit/settings_cubit.dart';
import 'package:food_diary/core/themes/custom_theme.dart';
import 'package:food_diary/features/diary/presentation/pages/diary_page.dart';
import 'package:food_diary/generated/l10n.dart';
import 'package:food_diary/injection_container.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  init();
  runApp(const FoodDiary());
}

class FoodDiary extends StatelessWidget {
  const FoodDiary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsCubit(),
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return MaterialApp(
            themeMode: state.settingsData.themeMode,
            theme: CustomTheme.lightTheme(),
            darkTheme: CustomTheme.darkTheme(),
            locale: Locale(state.settingsData.locale),
            localizationsDelegates: const [
              AppLocalization.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: AppLocalization.delegate.supportedLocales,
            onGenerateTitle: (context) => AppLocalization.of(context).appTitle,
            home: const DiaryPage(),
          );
        },
      ),
    );
  }
}
