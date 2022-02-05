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

  /// `No available information\n to show yet!`
  String get infoUnavailable {
    return Intl.message(
      'No available information\n to show yet!',
      name: 'infoUnavailable',
      desc: '',
      args: [],
    );
  }

  /// `Refresh`
  String get refresh {
    return Intl.message(
      'Refresh',
      name: 'refresh',
      desc: '',
      args: [],
    );
  }

  /// `Error!`
  String get error {
    return Intl.message(
      'Error!',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `Location permissions not allowed!`
  String get locationPermissions {
    return Intl.message(
      'Location permissions not allowed!',
      name: 'locationPermissions',
      desc: '',
      args: [],
    );
  }

  /// `Location service not available! Refresh!`
  String get locationService {
    return Intl.message(
      'Location service not available! Refresh!',
      name: 'locationService',
      desc: '',
      args: [],
    );
  }

  /// `\nHumidity`
  String get humidity {
    return Intl.message(
      '\nHumidity',
      name: 'humidity',
      desc: '',
      args: [],
    );
  }

  /// `\nPrecipitation`
  String get Precipitation {
    return Intl.message(
      '\nPrecipitation',
      name: 'Precipitation',
      desc: '',
      args: [],
    );
  }

  /// `\nWind Speed`
  String get windSpeed {
    return Intl.message(
      '\nWind Speed',
      name: 'windSpeed',
      desc: '',
      args: [],
    );
  }

  /// `\nPressure`
  String get Pressure {
    return Intl.message(
      '\nPressure',
      name: 'Pressure',
      desc: '',
      args: [],
    );
  }

  /// `Clear sky`
  String get clearSky {
    return Intl.message(
      'Clear sky',
      name: 'clearSky',
      desc: '',
      args: [],
    );
  }

  /// `Few clouds`
  String get fewClouds {
    return Intl.message(
      'Few clouds',
      name: 'fewClouds',
      desc: '',
      args: [],
    );
  }

  /// `Scattered clouds`
  String get scatteredClouds {
    return Intl.message(
      'Scattered clouds',
      name: 'scatteredClouds',
      desc: '',
      args: [],
    );
  }

  /// `Broken louds`
  String get brokenClouds {
    return Intl.message(
      'Broken louds',
      name: 'brokenClouds',
      desc: '',
      args: [],
    );
  }

  /// `Shower rain`
  String get showerRain {
    return Intl.message(
      'Shower rain',
      name: 'showerRain',
      desc: '',
      args: [],
    );
  }

  /// `Rain`
  String get rain {
    return Intl.message(
      'Rain',
      name: 'rain',
      desc: '',
      args: [],
    );
  }

  /// `Thunderstorm`
  String get thunderstorm {
    return Intl.message(
      'Thunderstorm',
      name: 'thunderstorm',
      desc: '',
      args: [],
    );
  }

  /// `Snow`
  String get snow {
    return Intl.message(
      'Snow',
      name: 'snow',
      desc: '',
      args: [],
    );
  }

  /// `Mist`
  String get mist {
    return Intl.message(
      'Mist',
      name: 'mist',
      desc: '',
      args: [],
    );
  }

  /// `Clear`
  String get clear {
    return Intl.message(
      'Clear',
      name: 'clear',
      desc: '',
      args: [],
    );
  }

  /// `Drizzle`
  String get drizzle {
    return Intl.message(
      'Drizzle',
      name: 'drizzle',
      desc: '',
      args: [],
    );
  }

  /// `Clouds`
  String get clouds {
    return Intl.message(
      'Clouds',
      name: 'clouds',
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
      Locale.fromSubtags(languageCode: 'pt'),
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
