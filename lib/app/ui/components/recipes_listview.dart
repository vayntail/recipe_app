import 'package:flutter/material.dart';
import 'package:recipe_app/app/model/recipe.dart';
import 'package:recipe_app/app/ui/components/recipe_button.dart';
import 'package:recipe_app/app/db/recipedb_operations.dart';

class RecipesListView extends StatefulWidget {
  const RecipesListView({super.key});

  @override
  State<RecipesListView> createState() => _RecipesListViewState();
}

class _RecipesListViewState extends State<RecipesListView> {
  /// Get recipes list from database.
  final RecipeOperations _recipeOperations = RecipeOperations();
  Future getRecipes() async {
    List<Recipe> recipesList = await _recipeOperations.getRecipes();
    return recipesList;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getRecipes(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Text('Loading...');
            default:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return RecipeButton(recipe: snapshot.data[index]);
                  },
                );
              }
          }
        });
  }
}
