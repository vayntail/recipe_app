import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
//Ensures that there is only one database existing.
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

//Ensures that the database is initialized and if not it runs it.
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'recipesapp.db');
// database tables and fields.
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE recipes (
          recipe_id INTEGER PRIMARY KEY AUTOINCREMENT,
          image_path TEXT CHECK(length(image_path) <= 30), 
          recipe_name TEXT CHECK(length(recipe_name) <= 20),
          hours INTEGER  CHECK(hours >= 0 AND hours <= 24),
          minutes INTEGER  CHECK(minutes >= 0 AND minutes < 60),
          directions TEXT CHECK(length(directions) <= 1000),
        )
      ''');
        await db.execute('''
        CREATE TABLE meal (
          meal_id INTEGER PRIMARY KEY AUTOINCREMENT,
          meal_type TEXT CHECK(meal_type IN ('Breakfast', 'Lunch', 'Dinner', 'Snack'))
          recipe_id INTEGER,
          FOREIGN KEY (recipe_id) REFERENCES recipes (recipe_id)
        )
      ''');
        await db.execute('''
        CREATE TABLE calendar (
          calendar_id INTEGER PRIMARY KEY AUTOINCREMENT,
          date TEXT 
        
        )
      ''');
        await db.execute('''
        CREATE TABLE ingredients (
          ingredient_id INTEGER PRIMARY KEY AUTOINCREMENT,
          recipe_id INTEGER,
          FOREIGN KEY (recipe_id) REFERENCES recipes (recipe_id)
          ingredient_name TEXT CHECK(length(ingredient_name) <= 20)
        
        )
      ''');
        await db.execute('''
        CREATE TABLE tag (
          tag_id INTEGER PRIMARY KEY AUTOINCREMENT,
          tag_name TEXT CHECK(length(tag_name) <= 15)
        
        )
      ''');
        await db.execute('''
        CREATE TABLE recipe_tag (
          recipe_id INTEGER,
          tag_id INTEGER,
          PRIMARY KEY (recipe_id, tag_id),
          FOREIGN KEY (recipe_id) REFERENCES recipe (recipe_id),
          FOREIGN KEY (tag_id) REFERENCES tag (tag_id)
        )
      ''');
        await db.execute('''
        CREATE TABLE calendar_meal (
        calendar_id INTEGER,
        meal_id INTEGER,
        PRIMARY KEY (calendar_id, meal_id),
        FOREIGN KEY (calendar_id) REFERENCES calendar (calendar_id),
        FOREIGN KEY (meal_id) REFERENCES meal (meal_id)
        );
      ''');
        await db.execute('''
        CREATE TABLE grocery_List (
        grocery_id INTEGER PRIMARY KEY AUTOINCREMENT,
        grocery_name TEXT CHECK(length(grocery_name) <= 20)
        );
      ''');
      },
    );
  }
}
