import 'package:sqflite/sqflite.dart';
import 'database.dart';

class RecipeOperations {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Get ingredients for a specific recipe
  Future<List<Map<String, dynamic>>> getIngredientsForRecipe(
      int recipeId) async {
    final db = await _dbHelper.database;
    return await db.query(
      'ingredients',
      where: 'recipe_id = ?',
      whereArgs: [recipeId],
    );
  }

  // Get meals for a specific recipe
  Future<List<Map<String, dynamic>>> getMealsForRecipe(int recipeId) async {
    final db = await _dbHelper.database;
    return await db.query(
      'meal',
      where: 'recipe_id = ?',
      whereArgs: [recipeId],
    );
  }

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

  // Get meals for a specific date
  Future<List<Map<String, dynamic>>> getMealsForDate(String date) async {
    final db = await _dbHelper.database;
    return await db.rawQuery('''
      SELECT m.meal_type, r.recipe_name
      FROM calendar_meal cm
      JOIN meal m ON cm.meal_id = m.meal_id
      JOIN recipes r ON m.recipe_id = r.recipe_id
      JOIN calendar c ON cm.calendar_id = c.calendar_id
      WHERE c.date = ?
    ''', [date]);
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

    // Insert the recipe into the database and return the recipe ID
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

  // Add a tag to a recipe
  Future<void> addTagToRecipe(int recipeId, String tagName) async {
    final db = await _dbHelper.database;

    // Insert tag and get its ID
    int tagId = await insertTag(tagName);

    // Link the tag to the recipe
    await db.insert('recipe_tag', {'recipe_id': recipeId, 'tag_id': tagId});
  }

  // Insert ingredients into a specific recipe
  Future<void> addIngredientToRecipe(int recipeId, String ingredient) async {
    final db = await _dbHelper.database;
    await db.insert(
      'ingredients',
      {
        'recipe_id': recipeId,
        'ingredient_name': ingredient,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all recipes
  Future<List<Map<String, dynamic>>> getRecipes() async {
    final db = await _dbHelper.database;

    // Query all recipes from the "recipes" table
    final List<Map<String, dynamic>> recipes = await db.query('recipes');

    return recipes;
  }
}
