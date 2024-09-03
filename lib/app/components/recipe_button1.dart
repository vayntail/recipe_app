import 'package:flutter/material.dart';

class RecipeButton1 extends StatelessWidget {
  const RecipeButton1({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Container(
        color: Colors.green,
        )));
  }
}