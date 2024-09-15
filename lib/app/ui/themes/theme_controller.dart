import 'package:flutter/material.dart';

class ThemeController {
  ThemeData themeData = ThemeData();
  BoxDecoration recipeButtonBoxDecoration = const BoxDecoration();

  void themeOne() {
    themeData = ThemeData(
        appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color.fromARGB(255, 255, 239, 239));
    recipeButtonBoxDecoration =
        BoxDecoration(border: Border.all(color: Colors.black, width: 1));
  }
}