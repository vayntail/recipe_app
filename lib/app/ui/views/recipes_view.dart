import 'package:flutter/material.dart';
import 'package:recipe_app/app/model/recipe.dart';
import 'package:recipe_app/app/ui/components/recipes_listview.dart';
import 'package:recipe_app/app/ui/screens/new_recipe_screen.dart';

class RecipesView extends StatefulWidget {
  const RecipesView({super.key});

  @override
  State<RecipesView> createState() => _RecipesViewState();
}

class _RecipesViewState extends State<RecipesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipes'),
        actions: <Widget>[
          /// Add new button
          IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'New Recipe',
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const NewRecipeScreen()) // Go to new recipe screen
                    );
              })
        ],
      ),
      body: const RecipesListView(),
    );
  }
}
