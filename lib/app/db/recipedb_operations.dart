import 'package:recipe_app/app/model/recipe.dart';
import 'package:sqflite/sqflite.dart';
import 'database.dart';

class RecipeOperations {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Get tags for a specific recipe
  Future<List<Map<String, dynamic>>> getTagsForRecipe(int recipeId) async {
    final db = await _dbHelper.database;
    return await db.rawQuery('''
      SELECT t.tag_name
      FROM recipe_tag rt
      JOIN tag t ON rt.tag_id = t.tag_id
      WHERE rt.recipe_id = ?
    ''', [recipeId]);
  }

  // Get recipes for a specific tag
  Future<List<Map<String, dynamic>>> getRecipesForTag(int tagId) async {
    final db = await _dbHelper.database;
    return await db.rawQuery('''
      SELECT r.recipe_name
      FROM recipe_tag rt
      JOIN recipes r ON rt.recipe_id = r.recipe_id
      WHERE rt.tag_id = ?
    ''', [tagId]);
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
    var result =
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
    int tagId = await insertTag(tagName);

    // Check if the recipe-tag combination already exists
    var result = await db.query(
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

  // Insert ingredients into a specific recipe
  Future<void> addIngredientToRecipe(int recipeId, String ingredient) async {
    final db = await _dbHelper.database;
    try {
      print('Adding ingredient: $ingredient'); // Log the ingredient being added
      await db.insert(
        'ingredients',
        {
          'recipe_id': recipeId,
          'ingredient_name': ingredient,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('Ingredient added successfully.');
    } catch (e) {
      print('Error adding ingredient: $e'); // Log any errors
    }
  }

  // Get all recipes with their tags
  Future<List<Recipe>> getRecipes() async {
    final db = await _dbHelper.database;
    List<Recipe> recipes = [];

    // Query all recipes from the "recipes" table
    final List<Map<String, dynamic>> dbRecipes = await db.query('recipes');

    for (var dbRecipe in dbRecipes) {
      // Fetch tags for the recipe
      final List<Map<String, dynamic>> recipeTags =
          await getTagsForRecipe(dbRecipe['recipe_id']);
      List<String> tags =
          recipeTags.map((tag) => tag['tag_name'] as String).toList();

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

    // Start a batch to ensure all related data is deleted
    final batch = db.batch();

    // Delete the recipe from the recipes table
    batch.delete(
      'recipes',
      where: 'recipe_id = ?',
      whereArgs: [recipeId],
    );

    // Optionally, delete related data from other tables
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

    // Commit the batch
    await batch.commit(noResult: true);

    // Delete unused tags
    await _deleteUnusedTags();
  }

  Future<void> _deleteUnusedTags() async {
    final db = await _dbHelper.database;

    // Fetch tags that are used by at least one recipe
    final tagsUsedResult = await db.rawQuery('''
    SELECT DISTINCT tag_id
    FROM recipe_tag
  ''');

    if (tagsUsedResult.isNotEmpty) {
      final usedTagIds =
          tagsUsedResult.map((row) => row['tag_id'] as int).toSet();

      // Only perform deletion if there are unused tags
      if (usedTagIds.isNotEmpty) {
        await db.delete(
          'tag',
          where: 'tag_id NOT IN (${usedTagIds.join(',')})',
        );
      }
    }
  }

  Future<void> deleteSingleTags() async {
    final Database db = await _dbHelper.database;

    // Delete tags that are not associated with any recipes
    await db.rawDelete('''
      DELETE FROM tag
      WHERE tag_id NOT IN (
        SELECT DISTINCT tag_id FROM recipe_tag
      )
    ''');
  }
}
