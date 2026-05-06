import 'package:flutter/material.dart';

ThemeData buildAppTheme() {
  const seed = Color(0xff256f68);

  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: const Color(0xfff5f7f9),
    appBarTheme: const AppBarTheme(centerTitle: false),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
      filled: true,
      fillColor: Colors.white,
    ),
    cardTheme: const CardThemeData(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        side: BorderSide(color: Color(0xffd9e1e7)),
      ),
    ),
  );
}
