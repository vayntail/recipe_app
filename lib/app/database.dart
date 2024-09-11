import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Singleton pattern: Private constructor
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  // Factory constructor
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  // The database instance
  static Database? _database;

  // Getter for the database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Method to initialize the database
  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'recipesapp.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Create recipes table
        await db.execute('''
          CREATE TABLE recipes (
          recipe_id INTEGER PRIMARY KEY AUTOINCREMENT,
          image_path VARCHAR(1000), 
          recipe_name TEXT CHECK(length(recipe_name) <= 20),
          recipe_description TEXT CHECK(length(recipe_description) <= 70),
          hours INTEGER CHECK(hours >= 0 AND hours <= 24),
          minutes INTEGER CHECK(minutes >= 0 AND minutes < 60),
          directions TEXT CHECK(length(directions) <= 1000),
          link TEXT CHECK(length(link) <= 100)
          )
        ''');

        // Create meal table
        await db.execute('''
          CREATE TABLE meal (
            meal_id INTEGER PRIMARY KEY AUTOINCREMENT,
            meal_type TEXT CHECK(meal_type IN ('Breakfast', 'Lunch', 'Dinner', 'Snack')),
            recipe_id INTEGER,
            FOREIGN KEY (recipe_id) REFERENCES recipes (recipe_id)
          )
        ''');

        // Create calendar table
        await db.execute('''
          CREATE TABLE calendar (
            calendar_id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT
          )
        ''');

        // Create ingredients table
        await db.execute('''
          CREATE TABLE ingredients (
            ingredient_id INTEGER PRIMARY KEY AUTOINCREMENT,
            recipe_id INTEGER,
            ingredient_name TEXT CHECK(length(ingredient_name) <= 20),
            FOREIGN KEY (recipe_id) REFERENCES recipes (recipe_id)
          )
        ''');

        // Create tag table
        await db.execute('''
          CREATE TABLE tag (
            tag_id INTEGER PRIMARY KEY AUTOINCREMENT,
            tag_name TEXT CHECK(length(tag_name) <= 15)
          )
        ''');

        // Create recipe_tag table
        await db.execute('''
          CREATE TABLE recipe_tag (
            recipe_id INTEGER,
            tag_id INTEGER,
            PRIMARY KEY (recipe_id, tag_id),
            FOREIGN KEY (recipe_id) REFERENCES recipes (recipe_id),
            FOREIGN KEY (tag_id) REFERENCES tag (tag_id)
          )
        ''');

        // Create calendar_meal table
        await db.execute('''
          CREATE TABLE calendar_meal (
            calendar_id INTEGER,
            meal_id INTEGER,
            PRIMARY KEY (calendar_id, meal_id),
            FOREIGN KEY (calendar_id) REFERENCES calendar (calendar_id),
            FOREIGN KEY (meal_id) REFERENCES meal (meal_id)
          )
        ''');

        // Create grocery_list table
        await db.execute('''
          CREATE TABLE grocery_list (
            grocery_id INTEGER PRIMARY KEY AUTOINCREMENT,
            grocery_name TEXT CHECK(length(grocery_name) <= 20)
          )
        ''');
      },
    );
  }
}
