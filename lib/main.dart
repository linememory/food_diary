import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_diary/core/app_scaffold/app_scaffold.dart';
import 'package:food_diary/core/settings/cubit/settings_cubit.dart';
import 'package:food_diary/core/themes/custom_theme.dart';
import 'package:food_diary/generated/l10n.dart';
import 'package:food_diary/injection_container.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const FoodDiary());
}

class FoodDiary extends StatelessWidget {
  const FoodDiary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsCubit(sl()),
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return MaterialApp(
            themeMode: state.settingsData.themeMode,
            theme: CustomTheme.lightTheme(),
            darkTheme: CustomTheme.darkTheme(),
            locale: Locale(state.settingsData.language.split('_').first),
            localizationsDelegates: const [
              AppLocalization.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: AppLocalization.delegate.supportedLocales,
            onGenerateTitle: (context) => AppLocalization.of(context).appTitle,
            home: const AppScaffold(), //const DiaryPage(),
          );
        },
      ),
    );
  }
}
