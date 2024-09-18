import 'package:flutter/material.dart';
import 'package:recipe_app/app/ui/widgets/texts_widget.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(title: appBarTitleText("Settings")),
      body: const Column(
        children: [
          Text("Themes"),
          Row(
            children: [ThemeBox(), ThemeBox()],
          ),
          Text("App Icon"),
          Row(
            children: [AppIconBox(), AppIconBox()],
          ),
        ]
      )
    );
  }
}

class ThemeBox extends StatelessWidget {
  const ThemeBox({super.key});

  @override
  Widget build(BuildContext context){
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black)
      )
    );
  }
}

class AppIconBox extends StatelessWidget {
  const AppIconBox({super.key});

  @override
  Widget build(BuildContext context){
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black)
      )
    );
  }
}