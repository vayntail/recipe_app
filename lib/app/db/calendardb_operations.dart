import 'package:sqflite/sqflite.dart';
import 'package:recipe_app/app/model/recipe.dart';
import 'package:recipe_app/app/model/calendar_day.dart';
import 'database.dart';

class CalendarOperations {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> addMealToCalendar(String date, int typeId, int recipeId) async {
    final db = await _dbHelper.database;
    await db.insert('meal', {
      'date': date,
      'type_id': typeId,
      'recipe_id': recipeId,
    });
  }

  Future<void> removeMealFromCalendar(
      String date, int typeId, int recipeId) async {
    final db = await _dbHelper.database;
    await db.delete(
      'meal',
      where: 'date = ? AND type_id = ? AND recipe_id = ?',
      whereArgs: [date, typeId, recipeId],
    );
  }

  Future<CalendarDay> getCalendarDay(String date) async {
    final db = await _dbHelper.database;
    final meals = await db.rawQuery('''
      SELECT m.meal_id, m.date, mt.type_name, r.*
      FROM meal m
      JOIN meal_types mt ON m.type_id = mt.type_id
      JOIN recipes r ON m.recipe_id = r.recipe_id
      WHERE m.date = ?
    ''', [date]);

    CalendarDay calendarDay = CalendarDay(
      day: date,
      breakfast: [],
      lunch: [],
      dinner: [],
      snacks: [],
    );

    for (var meal in meals) {
      Recipe recipe = Recipe.fromMap(meal);
      switch (meal['type_name'] as String) {
        case 'Breakfast':
          calendarDay.breakfast.add(recipe);
          break;
        case 'Lunch':
          calendarDay.lunch.add(recipe);
          break;
        case 'Dinner':
          calendarDay.dinner.add(recipe);
          break;
        case 'Snack':
          calendarDay.snacks.add(recipe);
          break;
      }
    }

    return calendarDay;
  }

  Future<List<CalendarDay>> getCalendarDays(
      DateTime start, DateTime end) async {
    List<CalendarDay> days = [];
    for (var day = start;
        day.isBefore(end.add(const Duration(days: 1)));
        day = day.add(const Duration(days: 1))) {
      String dateStr = day.toIso8601String().split('T')[0];
      CalendarDay calendarDay = await getCalendarDay(dateStr);
      days.add(calendarDay);
    }
    return days;
  }
}
