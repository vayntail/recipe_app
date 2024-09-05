import 'package:sqflite/sqflite.dart';

import 'database.dart';

class RecipeOperations {
  final DatabaseHelper _dbHelper = DatabaseHelper();
//getIngredientsForRecipe: One-to-many (recipes to ingredients)
  Future<List<Map<String, dynamic>>> getIngredientsForRecipe(
      int recipeId) async {
    final db = await _dbHelper.initDatabase();
    return await db.query(
      'ingredients',
      where: 'recipe_id = ?',
      whereArgs: [recipeId],
    );
  }

//getMealsForRecipe: One-to-many (recipes to meal)
  Future<List<Map<String, dynamic>>> getMealsForRecipe(int recipeId) async {
    final db = await _dbHelper.initDatabase();
    return await db.query(
      'meal',
      where: 'recipe_id = ?',
      whereArgs: [recipeId],
    );
  }

//getTagsForRecipe: Many-to-many (recipes to tags via recipe_tag)
  Future<List<Map<String, dynamic>>> getTagsForRecipe(int recipeId) async {
    final db = await _dbHelper.initDatabase();
    return await db.rawQuery('''
      SELECT t.tag_name
      FROM recipe_tag rt
      JOIN tag t ON rt.tag_id = t.tag_id
      WHERE rt.recipe_id = ?
    ''', [recipeId]);
  }

//getRecipesForTag: Many-to-many (tags to recipes via recipe_tag)
  Future<List<Map<String, dynamic>>> getRecipesForTag(int tagId) async {
    final db = await _dbHelper.initDatabase();
    return await db.rawQuery('''
      SELECT r.recipe_name
      FROM recipe_tag rt
      JOIN recipes r ON rt.recipe_id = r.recipe_id
      WHERE rt.tag_id = ?
    ''', [tagId]);
  }

//Get meals for a specific date
  Future<List<Map<String, dynamic>>> getMealsForDate(String date) async {
    final db = await _dbHelper.initDatabase();
    return await db.rawQuery('''
      SELECT m.meal_type, r.recipe_name
      FROM calendar_meal cm
      JOIN meal m ON cm.meal_id = m.meal_id
      JOIN recipes r ON m.recipe_id = r.recipe_id
      JOIN calendar c ON cm.calendar_id = c.calendar_id
      WHERE c.date = ?
    ''', [date]);
  }
}
