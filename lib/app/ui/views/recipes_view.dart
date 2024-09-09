import 'package:flutter/material.dart';
import 'package:recipe_app/app/model/recipe.dart';
import 'package:recipe_app/app/ui/components/search_container.dart';
import 'package:recipe_app/app/ui/components/recipe_button1.dart';
import 'package:recipe_app/app/ui/screens/new_recipe_screen.dart';

class RecipesView extends StatefulWidget {
  const RecipesView({super.key});

  @override
  State<RecipesView> createState() => _RecipesViewState();
}

class _RecipesViewState extends State<RecipesView> {

  /// List of Tags
  final List<String> tagsList = [
    "korean",
    "american",
  ];

  List<String> selectedTags = [];

  @override
  Widget build(BuildContext context) {

    /// filtered list of Recipes
    final filteredRecipes = recipesList.where((recipe) {
      if (selectedTags.isNotEmpty){
        for (var tag in recipe.tags){
          if (selectedTags.contains(tag)){
            return true;
          }
      }}
      return selectedTags.isEmpty;
    }).toList();

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
        body: Column(children: [
          /// Search bar
          const SearchContainer(),
          
          /// Tags Container
          Row(
            children: tagsList
                .map((tag) =>
                    FilterChip(
                      selected: selectedTags.contains(tag),
                      label: Text(tag), onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            selectedTags.add(tag);
                          } else {
                            selectedTags.remove(tag);
                          }
                        });
                      }))
                .toList(),
          ),
          Expanded(
            child: ListView.builder(
            itemCount: filteredRecipes.length,
            itemBuilder: (context, index){
              return RecipeButton1(recipe: filteredRecipes[index]);
            }),
            ),
        ]),
    );
  }
}
