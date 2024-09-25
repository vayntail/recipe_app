import 'package:recipe_app/app/model/recipe.dart';
import 'package:sqflite/sqflite.dart';
import 'database.dart';

class RecipeOperations {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Get tags for a specific recipe
  Future<List<String>> getTagsForRecipe(int recipeId) async {
    final db = await _dbHelper.database;

    // Fetch tags for the given recipeId
    final List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT t.tag_name
    FROM recipe_tag rt
    JOIN tag t ON rt.tag_id = t.tag_id
    WHERE rt.recipe_id = ?
  ''', [recipeId]);

    // Convert the result to a list of tag names
    return result.map((tag) => tag['tag_name'] as String).toList();
  }

  // Get recipes for a specific tag
  Future<List<String>> getRecipesForTag(int tagId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT r.recipe_name
      FROM recipe_tag rt
      JOIN recipes r ON rt.recipe_id = r.recipe_id
      WHERE rt.tag_id = ?
    ''', [tagId]);

    return result.map((recipe) => recipe['recipe_name'] as String).toList();
  }

  // Insert a recipe into the database
  Future<int> insertRecipe(
    String recipeName,
    String recipeDescription,
    String imagePath,
    int hours,
    int minutes,
    String directions,
    String link,
  ) async {
    final db = await _dbHelper.database;

    final Map<String, dynamic> recipe = {
      'recipe_name': recipeName,
      'recipe_description': recipeDescription,
      'image_path': imagePath,
      'hours': hours,
      'minutes': minutes,
      'directions': directions,
      'link': link,
    };

    return await db.insert('recipes', recipe);
  }

  // Insert a tag into the database
  Future<int> insertTag(String tagName) async {
    final db = await _dbHelper.database;

    // Check if the tag already exists
    final result =
        await db.query('tag', where: 'tag_name = ?', whereArgs: [tagName]);

    if (result.isNotEmpty) {
      return result.first['tag_id'] as int;
    } else {
      // Insert the new tag and return its ID
      return await db.insert('tag', {'tag_name': tagName});
    }
  }

  // Add a tag to a recipe, checking if the combination already exists
  Future<void> addTagToRecipeIfNotExists(int recipeId, String tagName) async {
    final db = await _dbHelper.database;

    // Insert tag and get its ID (this handles the case where the tag is new)
    final int tagId = await insertTag(tagName);

    // Check if the recipe-tag combination already exists
    final result = await db.query(
      'recipe_tag',
      where: 'recipe_id = ? AND tag_id = ?',
      whereArgs: [recipeId, tagId],
    );

    if (result.isEmpty) {
      // Link the tag to the recipe if it doesn't already exist
      await db.insert('recipe_tag', {'recipe_id': recipeId, 'tag_id': tagId});
    }
  }

  // Insert multiple tags into the database for a specific recipe
  Future<void> addTagsToRecipe(int recipeId, List<String> tagNames) async {
    for (String tagName in tagNames) {
      // Check the length of each tag before inserting
      if (tagName.length <= 15) {
        await addTagToRecipeIfNotExists(recipeId, tagName);
      } else {
        print('Tag "$tagName" exceeds the length limit.');
      }
    }
  }

  Future<List<String>> getIngredientsForRecipe(int recipeId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> result = await db.query(
      'ingredients',
      where: 'recipe_id = ?',
      whereArgs: [recipeId],
    );

    return result
        .map((ingredient) => ingredient['ingredient_name'] as String)
        .toList();
  }

  // Insert ingredients into a specific recipe
  Future<void> addIngredientToRecipe(int recipeId, String ingredient) async {
    final db = await _dbHelper.database;
    try {
      await db.insert(
        'ingredients',
        {
          'recipe_id': recipeId,
          'ingredient_name': ingredient,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('Ingredient added successfully: $ingredient');
    } catch (e) {
      print('Error adding ingredient: $e');
    }
  }

  // Get all recipes with their tags
  Future<List<Recipe>> getRecipes() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> dbRecipes = await db.query('recipes');
    List<Recipe> recipes = [];

    for (var dbRecipe in dbRecipes) {
      // Fetch tags and ingredients for the recipe
      final List<String> tags = await getTagsForRecipe(dbRecipe['recipe_id']);
      final List<String> ingredients =
          await getIngredientsForRecipe(dbRecipe['recipe_id']);

      // Add the recipe with ingredients and tags
      recipes.add(Recipe(
        recipeId: dbRecipe['recipe_id'],
        imagePath: dbRecipe['image_path'],
        recipeName: dbRecipe['recipe_name'],
        recipeDescription: dbRecipe['recipe_description'],
        hours: dbRecipe['hours'],
        minutes: dbRecipe['minutes'],
        directions: dbRecipe['directions'],
        link: dbRecipe['link'],
        tags: tags, // Provide the tags here
        ingredients: ingredients, // Provide the ingredients here
      ));
    }

    return recipes;
  }

  // Get all tags
  Future<List<String>> getAllTags() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> result = await db.query('tag');
    return result.map((row) => row['tag_name'] as String).toList();
  }

  // Delete a recipe by its ID
  Future<void> deleteRecipe(int recipeId) async {
    final db = await _dbHelper.database;

    final batch = db.batch();
    batch.delete(
      'recipes',
      where: 'recipe_id = ?',
      whereArgs: [recipeId],
    );
    batch.delete(
      'ingredients',
      where: 'recipe_id = ?',
      whereArgs: [recipeId],
    );
    batch.delete(
      'meal',
      where: 'recipe_id = ?',
      whereArgs: [recipeId],
    );
    batch.delete(
      'recipe_tag',
      where: 'recipe_id = ?',
      whereArgs: [recipeId],
    );

    await batch.commit(noResult: true);
    await _deleteUnusedTags();
  }

  Future<void> _deleteUnusedTags() async {
    final db = await _dbHelper.database;

    final tagsUsedResult = await db.rawQuery('''
    SELECT DISTINCT tag_id
    FROM recipe_tag
  ''');

    if (tagsUsedResult.isNotEmpty) {
      final usedTagIds =
          tagsUsedResult.map((row) => row['tag_id'] as int).toSet();

      if (usedTagIds.isNotEmpty) {
        await db.delete(
          'tag',
          where: 'tag_id NOT IN (${usedTagIds.join(',')})',
        );
      }
    }
  }

  Future<void> deleteSingleTags() async {
    final db = await _dbHelper.database;

    await db.rawDelete('''
      DELETE FROM tag
      WHERE tag_id NOT IN (
        SELECT DISTINCT tag_id FROM recipe_tag
      )
    ''');
  }

  Future<void> updateRecipe(
      int recipeId,
      String recipeName,
      String recipeDescription,
      String imagePath,
      int hours,
      int minutes,
      String directions,
      String link,
      List<String> tags,
      List<String> ingredients) async {
    final db = await _dbHelper.database;

    // Update recipe details
    final Map<String, dynamic> recipe = {
      'recipe_name': recipeName,
      'recipe_description': recipeDescription,
      'image_path': imagePath,
      'hours': hours,
      'minutes': minutes,
      'directions': directions,
      'link': link,
    };

    await db.update(
      'recipes',
      recipe,
      where: 'recipe_id = ?',
      whereArgs: [recipeId],
    );

    // Update tags and ingredients
    await updateTagsForRecipe(recipeId, tags);
    await updateIngredientsForRecipe(recipeId, ingredients);
  }

  // Update tags for a recipe
  Future<void> updateTagsForRecipe(int recipeId, List<String> newTags) async {
    final db = await _dbHelper.database;

    // Get the current tags from the database
    final List<String> currentTags = await getTagsForRecipe(recipeId);

    // Determine tags to remove
    for (String tag in currentTags) {
      if (!newTags.contains(tag)) {
        // Remove the tag if it's not in the new list
        final tagId =
            await _getTagId(tag); // You need to get the tag ID from its name
        await db.delete(
          'recipe_tag',
          where: 'recipe_id = ? AND tag_id = ?',
          whereArgs: [recipeId, tagId],
        );
      }
    }

    // Add new tags that don't exist yet
    for (String tag in newTags) {
      if (!currentTags.contains(tag)) {
        await addTagToRecipeIfNotExists(recipeId, tag);
      }
    }
  }

// Helper function to get tag ID by tag name
  Future<int?> _getTagId(String tagName) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> result =
        await db.query('tag', where: 'tag_name = ?', whereArgs: [tagName]);

    if (result.isNotEmpty) {
      return result.first['tag_id'] as int;
    }
    return null;
  }

  // Update ingredients for a recipe
  Future<void> updateIngredientsForRecipe(
      int recipeId, List<String> newIngredients) async {
    final db = await _dbHelper.database;

    // Get the current ingredients from the database
    final List<String> currentIngredients =
        await getIngredientsForRecipe(recipeId);

    // Determine ingredients to delete
    for (String ingredient in currentIngredients) {
      if (!newIngredients.contains(ingredient)) {
        await db.delete(
          'ingredients',
          where: 'recipe_id = ? AND ingredient_name = ?',
          whereArgs: [recipeId, ingredient],
        );
      }
    }

    // Determine new ingredients to add
    for (String ingredient in newIngredients) {
      if (!currentIngredients.contains(ingredient)) {
        await addIngredientToRecipe(recipeId, ingredient);
      }
    }
  }

// Get recipe object by recipe Id
  Future<Recipe> getRecipeFromId(int recipeId) async {
    final db = await _dbHelper.database;

    // Query recipe
    final List<Map<String, dynamic>> dbRecipes = await db
        .query('recipes', where: 'recipe_id = ?', whereArgs: [recipeId]);
    final Map<String, dynamic> dbRecipe = dbRecipes.first;

    // Convert into Recipe object
    Recipe recipe = Recipe(
        recipeId: dbRecipe['recipe_id'],
        imagePath: dbRecipe['image_path'],
        recipeName: dbRecipe['recipe_name'],
        recipeDescription: dbRecipe['recipe_description'],
        hours: dbRecipe['hours'],
        minutes: dbRecipe['minutes'],
        directions: dbRecipe['directions'],
        link: dbRecipe['link']);
    return recipe;
  }

  Future<List<Recipe>> getSortedRecipes(
      {required String sortBy, required bool ascending}) async {
    final db = await _dbHelper.database;
    String orderBy;

    switch (sortBy) {
      case 'alphabetical':
        orderBy = 'recipe_name';
        break;
      case 'chronological':
        orderBy = 'recipe_id';
        break;
      default:
        orderBy = 'recipe_id';
    }

    orderBy += ascending ? ' ASC' : ' DESC';

    final List<Map<String, dynamic>> dbRecipes =
        await db.query('recipes', orderBy: orderBy);
    List<Recipe> recipes = [];

    for (var dbRecipe in dbRecipes) {
      final List<String> tags = await getTagsForRecipe(dbRecipe['recipe_id']);
      final List<String> ingredients =
          await getIngredientsForRecipe(dbRecipe['recipe_id']);

      recipes.add(Recipe(
        recipeId: dbRecipe['recipe_id'],
        imagePath: dbRecipe['image_path'],
        recipeName: dbRecipe['recipe_name'],
        recipeDescription: dbRecipe['recipe_description'],
        hours: dbRecipe['hours'],
        minutes: dbRecipe['minutes'],
        directions: dbRecipe['directions'],
        link: dbRecipe['link'],
        tags: tags,
        ingredients: ingredients,
      ));
    }

    return recipes;
  }
}
