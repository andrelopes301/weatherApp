import 'package:flutter/material.dart';
import 'package:weather/DetailsSreen.dart';
import 'package:weather/HomeScreen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/l10n.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const {
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate //
      },
      supportedLocales: S.delegate.supportedLocales,
      title: 'WeatherApp',
      theme: ThemeData(
        //scaffoldBackgroundColor: Colors.lightBlue[800],
        brightness: Brightness.dark,
        // fontFamily: 'Consolas',
      ),
      initialRoute: HomeScreen.routeName,
      routes: {
        HomeScreen.routeName: (_) => const HomeScreen(),
        DetailsSreen.routeName: (_) => const DetailsSreen(),
      },
    );
  }
}
