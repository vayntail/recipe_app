import 'package:flutter/material.dart';
import 'package:recipe_app/app/views/calendar_view.dart';
import 'package:recipe_app/app/views/groceries_view.dart';
import 'package:recipe_app/app/views/recipe_view.dart';
import 'package:recipe_app/app/views/settings_view.dart';

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
        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a purple toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
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
      /// Title Bar
      appBar: [
        AppBar(title: const Text('Recipes'), actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'New Recipe',
              onPressed: () {})
        ]),
        AppBar(title: const Text('Groceries')),
        AppBar(title: const Text('Calendar'), actions: <Widget>[
                    IconButton(
              icon: const Icon(Icons.calendar_month),
              tooltip: 'Month View',
              onPressed: () {})
        ]),
        AppBar(title: const Text('Settings')),
      ][selectedIndex],


      /// Body
      body: [
        const RecipesView(),
        const GroceriesView(),
        const CalendarView(),
        const SettingsView(),
      ][selectedIndex],


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
