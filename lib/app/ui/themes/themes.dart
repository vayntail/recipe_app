import 'package:flutter/material.dart';

class Themes {
  ThemeData themeData = ThemeData(
    appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent),
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color.fromARGB(135, 250, 245, 245)
  );
}