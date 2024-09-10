import 'package:flutter/material.dart';
import 'package:recipe_app/app/themes.dart';
import 'package:recipe_app/app/ui/views/calendar_view.dart';
import 'package:recipe_app/app/ui/views/groceries_view.dart';
import 'package:recipe_app/app/ui/views/recipes_view.dart';
import 'package:recipe_app/app/ui/views/settings_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Recipe App',
        theme: Themes().themeData,
        debugShowCheckedModeBanner: false,
        home: const MainWrapper());
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Body
      body: Padding(
          padding: const EdgeInsets.only(top: 40), // Main Container Padding
          child: [
            const RecipesView(),
            const GroceriesView(),
            const CalendarView(),
            const SettingsView(),
          ][selectedIndex]),

      /// Bottom Nav Bar
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        selectedIndex: selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.food_bank),
            label: 'Recipes',
          ),
          NavigationDestination(
            icon: Icon(Icons.list),
            label: 'Groceries',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
