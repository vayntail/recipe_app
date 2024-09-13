import 'package:recipe_app/app/model/grocery_item.dart';
import 'package:sqflite/sqflite.dart';
import 'database.dart';

class GroceryOperations {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Update user's grocery item state
  Future<void> updateGroceryItem(GroceryItem groceryItem) async {
    final db = await _dbHelper.database;

    await db.update(
      'grocery_list',
      groceryItem.toMap(),
      // Ensure id matches
      where: 'grocery_id = ?',
      whereArgs: [groceryItem.id],
    );
  }

  // Clear all Grocery List Table Data
  clearGroceryList() async {
    Database db = await _dbHelper.database;
    return await db.rawDelete("DELETE FROM grocery_list");
  }

  // Delete one grocery list item
  deleteGroceryItem(GroceryItem item) async {
    Database db = await _dbHelper.database;
    return await db.rawDelete("DELETE FROM grocery_list WHERE id = ?", [item.id]);
  }


  // Update 

  // Insert GroceryItem
  Future insertGroceryItem(GroceryItem item) async {
    final db = await _dbHelper.database;

    // Insert grocery item into the database
    await db.insert(
      'grocery_list', 
      item.toMap(),);
  }



  // Get user's grocery list (list of ingredients)
  Future<List<GroceryItem>> getGroceryList() async {
    final db = await _dbHelper.database;

    // Query all recipes from the "grocery_list" table
    final List<Map<String, dynamic>> dbMaps =
      await db.query('grocery_list');

    // Convert into GroceryItem objects
    return [
      for (final {
        'grocery_id': id as int,
        'grocery_name': name as String,
        'checked': checked as int,
      } in dbMaps)
      GroceryItem(id: id, name: name, checked: checked),
    ];
  }
}
