import 'package:flutter/material.dart';
import 'package:recipe_app/app/components/recipe_button1.dart';

class RecipesView extends StatelessWidget {
  const RecipesView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
        children: [
          Text('Recipes'),
          RecipeButton1(),
          RecipeButton1(),
          RecipeButton1(),
        ]);
  }
}
