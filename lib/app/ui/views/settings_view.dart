import 'package:flutter/material.dart';
import 'package:recipe_app/app/ui/widgets/texts_widget.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        centerTitle: false,title: appBarTitleText("Settings")),
      body: const Column(
        children: [
        ]
      )
    );
  }
}