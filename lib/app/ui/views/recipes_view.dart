import 'package:flutter/material.dart';
import 'package:recipe_app/app/ui/components/recipes_listview.dart';
import 'package:recipe_app/app/ui/screens/new_recipe_screen.dart';

class RecipesView extends StatefulWidget {
  final ValueNotifier<void> notifier;

  const RecipesView({super.key, required this.notifier});

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
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'New Recipe',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewRecipeScreen(
                    onRecipeSaved: () {
                      widget.notifier.notifyListeners();
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: RecipesListView(
        isMealSelection: false,
        notifier: widget.notifier,
      ),
    );
  }
}
