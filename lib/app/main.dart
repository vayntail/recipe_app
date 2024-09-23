import 'package:flutter/material.dart';
import 'package:recipe_app/app/ui/themes/theme_controller.dart';
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
      theme: ThemeController().themeData,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Body
      body: Padding(
        padding: const EdgeInsets.only(top: 40), // Main Container Padding
        child: [
          Stack(
            children: [
              const RecipesView(),
              // Cute cat picture
              Positioned(
                top: 10,
                left: 5,
                child: SizedBox(
                  width: 160,
                  height: 100,
                  child: Image.asset("assets/cats/recipe_cat.png"),)
              ),
            ],
          ),
          Stack(
            children: [
              const GroceriesView(),
              // Cute cat picture
              Positioned(
                top: 15,
                left: 5,
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.asset("assets/cats/grocery_cat.png"),)
              ),
            ],
          ),
          Stack(
            children: [
              const CalendarView(),
              // Cute cat picture
              Positioned(
                top: 10,
                left: 5,
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.asset("assets/cats/calendar_cat.png"),)
              ),
            ],
          ),
          Stack(
            children: [
              const SettingsView(),
              // Cute cat picture
              Positioned(
                top: 14,
                left: 5,
                child: SizedBox(
                  width: 160,
                  height: 100,
                  child: Image.asset("assets/cats/setting_cat.png"),)
              ),
            ],
          ),
        ][selectedIndex],
      ),

      /// Bottom Nav Bar
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(width: 1.5, color: Color.fromARGB(255, 177, 124, 120))
            )
        ),
        child: NavigationBar(
          indicatorColor: const Color.fromARGB(0, 255, 255, 255),
          height: 95,
          
          selectedIndex: selectedIndex,
          onDestinationSelected: (int index) {
            setState(() {
              selectedIndex = index;
            });
          },
          destinations: <Widget>[
            NavigationDestination(
              icon: Image.asset("assets/nav-icons/recipes_inactive.png"),
              selectedIcon: Image.asset("assets/nav-icons/recipes_active.png"),
              label: 'Recipes',
            ),
            NavigationDestination(
              icon: Image.asset("assets/nav-icons/groceries_inactive.png"),
              selectedIcon: Image.asset("assets/nav-icons/groceries_active.png"),
              label: 'Groceries',
            ),
            NavigationDestination(
              icon: Image.asset("assets/nav-icons/calendar_inactive.png"),
              selectedIcon: Image.asset("assets/nav-icons/calendar_active.png"),
              label: 'Calendar',
            ),
            NavigationDestination(
              icon: Image.asset("assets/nav-icons/settings_inactive.png"),
              selectedIcon: Image.asset("assets/nav-icons/settings_active.png"),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
