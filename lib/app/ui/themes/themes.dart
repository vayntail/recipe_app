import 'package:flutter/material.dart';

class Themes {
  ThemeData themeData = ThemeData(
    appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent),
    navigationBarTheme: NavigationBarThemeData(backgroundColor: const Color.fromARGB(95, 245, 158, 158)),
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color.fromARGB(255, 238, 219, 219)
  );
}