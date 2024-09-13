import 'package:flutter/material.dart';
import 'package:recipe_app/app/ui/themes/themes.dart';
import 'package:recipe_app/app/ui/views/calendar_view.dart';
import 'package:recipe_app/app/ui/views/groceries_view.dart';
import 'package:recipe_app/app/ui/views/recipes_view.dart';
import 'package:recipe_app/app/ui/views/settings_view.dart';
// Import your new recipe screen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe App',
      theme: Themes().themeData,
      debugShowCheckedModeBanner: false,
      home: const MainWrapper(),
    );
  }
}

/// Main Layout Wrapper
class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int selectedIndex = 0;
  final ValueNotifier<void> _recipesNotifier =
      ValueNotifier<void>(null); // ValueNotifier for recipes

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Body
      body: Padding(
        padding: const EdgeInsets.only(top: 40), // Main Container Padding
        child: [
          RecipesView(notifier: _recipesNotifier), // Pass the notifier
          const GroceriesView(),
          const CalendarView(),
          const SettingsView(),
        ][selectedIndex],
      ),

      /// Bottom Nav Bar
      bottomNavigationBar: NavigationBar(
        indicatorColor: const Color.fromARGB(0, 255, 255, 255),
        height: 110,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        selectedIndex: selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: <Widget>[
          NavigationDestination(
            icon: Image.asset("assets/icons/recipes_inactive.png"),
            selectedIcon: Image.asset("assets/icons/recipes_active.png"),
            label: 'Recipes',
          ),
          NavigationDestination(
            icon: Image.asset("assets/icons/groceries_inactive.png"),
            selectedIcon: Image.asset("assets/icons/groceries_active.png"),
            label: 'Groceries',
          ),
          NavigationDestination(
            icon: Image.asset("assets/icons/calendar_inactive.png"),
            selectedIcon: Image.asset("assets/icons/calendar_active.png"),
            label: 'Calendar',
          ),
          NavigationDestination(
            icon: Image.asset("assets/icons/settings_inactive.png"),
            selectedIcon: Image.asset("assets/icons/settings_active.png"),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
