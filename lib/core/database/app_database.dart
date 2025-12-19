import 'package:notesapp/core/database/database_helper.dart';
import 'package:notesapp/features/notes/data/model/note_model.dart';
import 'package:sqflite/sqflite.dart';

abstract class AppDatabase<T> {
  String get boxName;

  Future<Database> _getDatabase() async {
    return await DatabaseHelper.instance.database;
  }

  Future<T> create(T item) async {
    try {
      final db = await _getDatabase();
      final json = (item as NoteModel).toJson();
      final id = await db.insert(
        boxName,
        json,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // Return the item with the generated ID
      final result = await db.query(
        boxName,
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (result.isEmpty) {
        throw Exception('Failed to retrieve created item');
      }

      return NoteModel.fromJson(result.first) as T;
    } catch (e) {
      throw Exception('Failed to create item: $e');
    }
  }

  Future<List<T>> list({Map<String, dynamic>? filters}) async {
    try {
      final db = await _getDatabase();

      String? whereClause;
      List<dynamic>? whereArgs;

      if (filters != null && filters.isNotEmpty) {
        final conditions = <String>[];
        final args = <dynamic>[];

        filters.forEach((key, value) {
          conditions.add('$key = ?');
          // Convert bool to int for SQLite
          if (value is bool) {
            args.add(value ? 1 : 0);
          } else {
            args.add(value);
          }
        });

        whereClause = conditions.join(' AND ');
        whereArgs = args;
      }

      final result = await db.query(
        boxName,
        where: whereClause,
        whereArgs: whereArgs,
        orderBy: 'updatedAt DESC',
      );

      return result.map((json) => NoteModel.fromJson(json) as T).toList();
    } catch (e) {
      throw Exception('Failed to list items: $e');
    }
  }

  Future<T?> find(int id) async {
    try {
      final db = await _getDatabase();
      final result = await db.query(
        boxName,
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (result.isEmpty) return null;
      return NoteModel.fromJson(result.first) as T;
    } catch (e) {
      throw Exception('Failed to find item: $e');
    }
  }

  Future<T> update(T item) async {
    try {
      final db = await _getDatabase();
      final noteModel = item as NoteModel;

      if (noteModel.id == null) {
        throw Exception('Cannot update item without ID');
      }

      final json = noteModel.toJson();

      await db.update(
        boxName,
        json,
        where: 'id = ?',
        whereArgs: [noteModel.id],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      return item;
    } catch (e) {
      throw Exception('Failed to update item: $e');
    }
  }

  Future<void> delete(int id) async {
    try {
      final db = await _getDatabase();
      await db.delete(boxName, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      throw Exception('Failed to delete item: $e');
    }
  }

  Future<void> clear() async {
    try {
      final db = await _getDatabase();
      await db.delete(boxName);
    } catch (e) {
      throw Exception('Failed to clear table: $e');
    }
  }

  Future<bool> containsKey(int id) async {
    try {
      final db = await _getDatabase();
      final result = await db.query(
        boxName,
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );
      return result.isNotEmpty;
    } catch (e) {
      throw Exception('Failed to check if key exists: $e');
    }
  }

  Future<int> count() async {
    try {
      final db = await _getDatabase();
      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM $boxName',
      );
      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e) {
      throw Exception('Failed to count items: $e');
    }
  }
}
