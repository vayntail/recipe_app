import 'package:flutter/material.dart';
import 'package:recipe_app/app/model/recipe.dart';
import 'package:recipe_app/app/ui/components/recipes_listview.dart';
import 'package:recipe_app/app/ui/screens/new_recipe_screen.dart';
import 'package:recipe_app/app/ui/screens/recipe_profile.dart';
import 'package:recipe_app/app/ui/widgets/texts_widget.dart';

class RecipesView extends StatefulWidget {

  const RecipesView({super.key});

  @override
  State<RecipesView> createState() => _RecipesViewState();
}

class _RecipesViewState extends State<RecipesView> {

  // Go to recipe details screen
  openRecipeDetailsScreen(Recipe recipe) {
    Navigator.push(context,
    MaterialPageRoute(builder: (context) => RecipeDetailsScreen(recipe: recipe)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBarTitleText('Recipes'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'New Recipe',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewRecipeScreen(
                    onRecipeSaved: (Recipe recipe) {
                      openRecipeDetailsScreen(recipe);
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.only(top: 20),
        child: RecipesListView(
              isMealSelection: false,
            ),
      )
      );
  }
}
