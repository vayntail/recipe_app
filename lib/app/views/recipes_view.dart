import 'package:flutter/material.dart';
import 'package:recipe_app/app/components/recipe_button1.dart';
import 'package:recipe_app/app/components/search_tags_container.dart';
import 'package:recipe_app/app/screens/new_recipe_screen.dart';

class RecipesView extends StatelessWidget {
  const RecipesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipes'), actions: <Widget>[
        /// Add new button
          IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'New Recipe',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NewRecipeScreen()) // Go to new recipe screen
                );
              })
              ],
        ),
        body: Column(
            children: <Widget>[
              const SearchTagsContainer(),
              Expanded(child: ListView(
                padding: EdgeInsets.all(8),
            children: const <Widget>[
              RecipeButton1(name: "Name1", description: "Description1", minutes: 30),
              RecipeButton1(name: "Name2", description: "Description2", minutes: 30),
              RecipeButton1(name: "Name3", description: "Description3", minutes: 30),
              RecipeButton1(name: "Name3", description: "Description3", minutes: 30),
              RecipeButton1(name: "Name3", description: "Description3", minutes: 30),
              RecipeButton1(name: "Name3", description: "Description3", minutes: 30),
             ],
            )
            )
          ]
        )
    );
  }
}


