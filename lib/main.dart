import 'package:flutter/material.dart';
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
    return MaterialApp(
      title: 'Food Diary',
      home: const DiaryPage(),
      themeMode: ThemeMode.system,
      theme: CustomTheme.lightTheme(),
      darkTheme: CustomTheme.darkTheme(),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
    );
  }
}
