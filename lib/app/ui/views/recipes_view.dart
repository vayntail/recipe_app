import 'package:flutter/material.dart';
import 'package:recipe_app/app/model/recipe.dart';
import 'package:recipe_app/app/ui/components/recipe_button1.dart';
import 'package:recipe_app/app/ui/screens/new_recipe_screen.dart';

class RecipesView extends StatefulWidget {
  const RecipesView({super.key});

  @override
  State<RecipesView> createState() => _RecipesViewState();
}

class _RecipesViewState extends State<RecipesView> {
  /// Call recipesList from recipe.dart

  /// List of Tags created from the Recipes List
  final List<String> tagsList = [];
  void setTagsList() {
    for (var recipe in recipesList) {
      for (var tag in recipe.tags) {
        if (!tagsList.contains(tag)) {
          tagsList.add(tag);
        }
      }
    }
  }

  String selectedTag = ""; // Selected Tag
  bool searching = false;
  /// Search bar stuff
  /// 
  List<Recipe> searchResults = [];
  void onQueryChanged(String query) {
    setState(() {

      if (query==""){
        searching = false;
      }
      else {
        searching = true;
      }
      searchResults = recipesList
          .where((recipe) =>
              recipe.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    setTagsList(); // Set the List

    /// filtered list of Recipes
    List<Recipe> filteredRecipes = [];
    void setFilteredRecipes() {
      // debugPrint("searching: ${searching}, SelectedTag: ${selectedTag}, searchBarFocused: ${searchBarFocused}, searchResults: ${searchResults}");

      // Shows filtered results from both search bar and selected Tag.
      if (selectedTag.isEmpty) {
        if (searchResults.isNotEmpty) {
          filteredRecipes = searchResults;
        } else {
          if (searching){
            filteredRecipes = searchResults;
          }
          else {
            filteredRecipes = recipesList;
          }
        }
      } else { // selected tag is Not empty
        for (var recipe in recipesList) {
          for (var tag in recipe.tags) {
            if (selectedTag == tag) {
              if (!searching){
                filteredRecipes.add(recipe);
              }
              else {
                if (searchResults.contains(recipe)){
                  filteredRecipes.add(recipe);
                }
              }
            } else {
              filteredRecipes.remove(recipe);
            }
          }
        }
      } 
    }
    setFilteredRecipes();

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
      body: Column(

        crossAxisAlignment: CrossAxisAlignment.start, children: [
        /// Search bar
        Container(
        padding: EdgeInsets.only(left: 8, right: 8),
          width: 300,
          child: TextField(
            onChanged: onQueryChanged,
            decoration: const InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
                floatingLabelBehavior: FloatingLabelBehavior.never),
          ),
        ),

        /// Tags Container
        Row(
          children: tagsList
              .map((tag) => FilterChip(
                selectedColor: const Color.fromARGB(255, 223, 212, 212),
                  showCheckmark: false,
                  selected: selectedTag.contains(tag),
                  label: Text(tag),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        selectedTag = tag;
                      } else {
                        selectedTag = "";
                      }
                    });
                  }))
              .toList(),
        ),
        Expanded(
          child: ListView.builder(
              itemCount: filteredRecipes.length,
              itemBuilder: (context, index) {
                return RecipeButton1(recipe: filteredRecipes[index]);
              }),
        ),
      ]),
    );
  }
}
