import 'package:sqflite/sqflite.dart';
import 'database.dart';

class RecipeOperations {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<Map<String, dynamic>>> getIngredientsForRecipe(
      int recipeId) async {
    final db = await _dbHelper.database;
    return await db.query(
      'ingredients',
      where: 'recipe_id = ?',
      whereArgs: [recipeId],
    );
  }

  Future<List<Map<String, dynamic>>> getMealsForRecipe(int recipeId) async {
    final db = await _dbHelper.database;
    return await db.query(
      'meal',
      where: 'recipe_id = ?',
      whereArgs: [recipeId],
    );
  }

  Future<List<Map<String, dynamic>>> getTagsForRecipe(int recipeId) async {
    final db = await _dbHelper.database;
    return await db.rawQuery('''
      SELECT t.tag_name
      FROM recipe_tag rt
      JOIN tag t ON rt.tag_id = t.tag_id
      WHERE rt.recipe_id = ?
    ''', [recipeId]);
  }

  Future<List<Map<String, dynamic>>> getRecipesForTag(int tagId) async {
    final db = await _dbHelper.database;
    return await db.rawQuery('''
      SELECT r.recipe_name
      FROM recipe_tag rt
      JOIN recipes r ON rt.recipe_id = r.recipe_id
      WHERE rt.tag_id = ?
    ''', [tagId]);
  }

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

  Future<int> insertRecipe(
    String recipeName,
    String recipeDescription,
    String imagePath,
    int hours,
    int minutes,
    String directions,
    String link,
  ) async {
    try {
      final db = await _dbHelper.database;

      // Debugging output
      print("Validating data...");
      print("recipeName length: ${recipeName.length}");
      print("recipeDescription length: ${recipeDescription.length}");
      print("directions length: ${directions.length}");
      print("link length: ${link.length}");
      print("hours: $hours");
      print("minutes: $minutes");

      // Validate data
      if (recipeName.length > 20 ||
          recipeDescription.length > 70 ||
          directions.length > 1000 ||
          link.length > 100 ||
          hours < 0 ||
          hours > 24 ||
          minutes < 0 ||
          minutes >= 60) {
        throw ArgumentError('Invalid data for recipe');
      }

      final Map<String, dynamic> recipe = {
        'recipe_name': recipeName,
        'recipe_description': recipeDescription,
        'image_path': imagePath,
        'hours': hours,
        'minutes': minutes,
        'directions': directions,
        'link': link,
      };

      print("Inserting recipe: $recipe");
      final result = await db.insert('recipes', recipe);
      print("Insert result: $result");
      return result;
    } catch (e) {
      print('Error inserting recipe: $e');
      rethrow;
    }
  }

  Future<int> insertTag(String tagName) async {
    final db = await _dbHelper.database;

    var result =
        await db.query('tag', where: 'tag_name = ?', whereArgs: [tagName]);

    if (result.isNotEmpty) {
      return result.first['tag_id'] as int;
    } else {
      return await db.insert('tag', {'tag_name': tagName});
    }
  }

  Future<void> addTagToRecipe(int recipeId, String tagName) async {
    final db = await _dbHelper.database;
    int tagId = await insertTag(tagName);
    await db.insert('recipe_tag', {'recipe_id': recipeId, 'tag_id': tagId});
  }

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

  Future<List<Map<String, dynamic>>> getRecipes() async {
    final db = await _dbHelper.database;
    return await db.query('recipes');
  }
}
