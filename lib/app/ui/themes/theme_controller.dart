import 'package:flutter/material.dart';

class ThemeController {
  ThemeData themeData = ThemeData(
    fontFamily: 'NanumPenScript',
    navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color.fromARGB(255, 255, 205, 202),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontFamily: "Mansalva",
              color: Color.fromARGB(255, 59, 58, 55),
            );
          } else {
            return const TextStyle(
              fontFamily: "Mansalva",
              color: Color.fromARGB(125, 59, 58, 55),
            );
          }
        })),
    appBarTheme:
        const AppBarTheme(backgroundColor: Color.fromARGB(0, 255, 255, 255)),
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    useMaterial3: true,
    scaffoldBackgroundColor: const Color.fromARGB(255, 247, 234, 228),
  );
}
