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

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
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
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
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
