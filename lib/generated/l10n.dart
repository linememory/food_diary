// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class AppLocalization {
  AppLocalization();

  static AppLocalization? _current;

  static AppLocalization get current {
    assert(_current != null,
        'No instance of AppLocalization was loaded. Try to initialize the AppLocalization delegate before accessing AppLocalization.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<AppLocalization> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = AppLocalization();
      AppLocalization._current = instance;

      return instance;
    });
  }

  static AppLocalization of(BuildContext context) {
    final instance = AppLocalization.maybeOf(context);
    assert(instance != null,
        'No instance of AppLocalization present in the widget tree. Did you add AppLocalization.delegate in localizationsDelegates?');
    return instance!;
  }

  static AppLocalization? maybeOf(BuildContext context) {
    return Localizations.of<AppLocalization>(context, AppLocalization);
  }

  /// `Food Diary App`
  String get appTitle {
    return Intl.message(
      'Food Diary App',
      name: 'appTitle',
      desc: '',
      args: [],
    );
  }

  /// `Diary`
  String get diaryPageTitle {
    return Intl.message(
      'Diary',
      name: 'diaryPageTitle',
      desc: '',
      args: [],
    );
  }

  /// `Add meal to diary`
  String get addMealTooltip {
    return Intl.message(
      'Add meal to diary',
      name: 'addMealTooltip',
      desc: '',
      args: [],
    );
  }

  /// `Add Symptom to diary`
  String get addSymptomTooltip {
    return Intl.message(
      'Add Symptom to diary',
      name: 'addSymptomTooltip',
      desc: '',
      args: [],
    );
  }

  /// `Add Bowel Movement to diary`
  String get addBowelMovementTooltip {
    return Intl.message(
      'Add Bowel Movement to diary',
      name: 'addBowelMovementTooltip',
      desc: '',
      args: [],
    );
  }

  /// `Diary List`
  String get diaryBottomNavigationBarLabel {
    return Intl.message(
      'Diary List',
      name: 'diaryBottomNavigationBarLabel',
      desc: '',
      args: [],
    );
  }

  /// `Calendar`
  String get calendarBottomNavigationBarLabel {
    return Intl.message(
      'Calendar',
      name: 'calendarBottomNavigationBarLabel',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get diaryEntryUpdate {
    return Intl.message(
      'Update',
      name: 'diaryEntryUpdate',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get diaryEntryDelete {
    return Intl.message(
      'Delete',
      name: 'diaryEntryDelete',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get diaryFormAdd {
    return Intl.message(
      'Add',
      name: 'diaryFormAdd',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get diaryFormUpdate {
    return Intl.message(
      'Update',
      name: 'diaryFormUpdate',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get diaryFormCancel {
    return Intl.message(
      'Cancel',
      name: 'diaryFormCancel',
      desc: '',
      args: [],
    );
  }

  /// `Small`
  String get foodAmountSmall {
    return Intl.message(
      'Small',
      name: 'foodAmountSmall',
      desc: '',
      args: [],
    );
  }

  /// `Medium`
  String get foodAmountMedium {
    return Intl.message(
      'Medium',
      name: 'foodAmountMedium',
      desc: '',
      args: [],
    );
  }

  /// `High`
  String get foodAmountHigh {
    return Intl.message(
      'High',
      name: 'foodAmountHigh',
      desc: '',
      args: [],
    );
  }

  /// `Low`
  String get symptomIntensityLow {
    return Intl.message(
      'Low',
      name: 'symptomIntensityLow',
      desc: '',
      args: [],
    );
  }

  /// `Medium`
  String get symptomIntensityMedium {
    return Intl.message(
      'Medium',
      name: 'symptomIntensityMedium',
      desc: '',
      args: [],
    );
  }

  /// `High`
  String get symptomIntensityHigh {
    return Intl.message(
      'High',
      name: 'symptomIntensityHigh',
      desc: '',
      args: [],
    );
  }

  /// `Type 1`
  String get stoolType1 {
    return Intl.message(
      'Type 1',
      name: 'stoolType1',
      desc: '',
      args: [],
    );
  }

  /// `Type 2`
  String get stoolType2 {
    return Intl.message(
      'Type 2',
      name: 'stoolType2',
      desc: '',
      args: [],
    );
  }

  /// `Type 3`
  String get stoolType3 {
    return Intl.message(
      'Type 3',
      name: 'stoolType3',
      desc: '',
      args: [],
    );
  }

  /// `Type 4`
  String get stoolType4 {
    return Intl.message(
      'Type 4',
      name: 'stoolType4',
      desc: '',
      args: [],
    );
  }

  /// `Type 5`
  String get stoolType5 {
    return Intl.message(
      'Type 5',
      name: 'stoolType5',
      desc: '',
      args: [],
    );
  }

  /// `Type 6`
  String get stoolType6 {
    return Intl.message(
      'Type 6',
      name: 'stoolType6',
      desc: '',
      args: [],
    );
  }

  /// `Type 7`
  String get stoolType7 {
    return Intl.message(
      'Type 7',
      name: 'stoolType7',
      desc: '',
      args: [],
    );
  }

  /// `No entry to delete`
  String get diaryDeleteFailureNoMeal {
    return Intl.message(
      'No entry to delete',
      name: 'diaryDeleteFailureNoMeal',
      desc: '',
      args: [],
    );
  }

  /// `Entry could not be deleted`
  String get diaryDeleteFailureNotDeleted {
    return Intl.message(
      'Entry could not be deleted',
      name: 'diaryDeleteFailureNotDeleted',
      desc: '',
      args: [],
    );
  }

  /// `Failed to add entry:\n `
  String get entryFormSubmitFailed {
    return Intl.message(
      'Failed to add entry:\n ',
      name: 'entryFormSubmitFailed',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get settingsFormSave {
    return Intl.message(
      'Save',
      name: 'settingsFormSave',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get settingsFormCancel {
    return Intl.message(
      'Cancel',
      name: 'settingsFormCancel',
      desc: '',
      args: [],
    );
  }

  /// `Themes`
  String get settingsFormThemesLabel {
    return Intl.message(
      'Themes',
      name: 'settingsFormThemesLabel',
      desc: '',
      args: [],
    );
  }

  /// `Languages`
  String get settingsFormLanguagesLabel {
    return Intl.message(
      'Languages',
      name: 'settingsFormLanguagesLabel',
      desc: '',
      args: [],
    );
  }

  /// `System`
  String get themeModeSystem {
    return Intl.message(
      'System',
      name: 'themeModeSystem',
      desc: '',
      args: [],
    );
  }

  /// `Light`
  String get themeModeLight {
    return Intl.message(
      'Light',
      name: 'themeModeLight',
      desc: '',
      args: [],
    );
  }

  /// `Dark`
  String get themeModeDark {
    return Intl.message(
      'Dark',
      name: 'themeModeDark',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get languageEnglish {
    return Intl.message(
      'English',
      name: 'languageEnglish',
      desc: '',
      args: [],
    );
  }

  /// `German`
  String get languageGerman {
    return Intl.message(
      'German',
      name: 'languageGerman',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalization> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'de', countryCode: 'DE'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<AppLocalization> load(Locale locale) => AppLocalization.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
