import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// SQLite database service for managing favorite restaurants.
///
/// Features:
/// - Lazy database initialization
/// - CRUD operations for favorites table
/// - Duplicate prevention with ConflictAlgorithm.replace
class FavoritesDatabaseService {
  static const String _databaseName = 'kulinere_favorites.db';
  static const String _tableName = 'favorites';
  static const int _version = 1;

  Database? _database;

  /// Returns database instance, initializing if needed.
  Future<Database> get database async {
    _database ??= await _initializeDb();
    return _database!;
  }

  Future<Database> _initializeDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    return openDatabase(path, version: _version, onCreate: _createTables);
  }

  Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        city TEXT NOT NULL,
        rating REAL NOT NULL,
        pictureId TEXT NOT NULL
      )
    ''');
  }

  /// Inserts a favorite restaurant. Replaces if already exists.
  Future<int> insertFavorite(Map<String, dynamic> data) async {
    final db = await database;
    return db.insert(
      _tableName,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Returns all favorite restaurants.
  Future<List<Map<String, dynamic>>> getAllFavorites() async {
    final db = await database;
    return db.query(_tableName);
  }

  /// Returns a single favorite by ID, or null if not found.
  Future<Map<String, dynamic>?> getFavoriteById(String id) async {
    final db = await database;
    final results = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return results.isEmpty ? null : results.first;
  }

  /// Deletes a favorite by ID. Returns number of rows affected.
  Future<int> deleteFavorite(String id) async {
    final db = await database;
    return db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  /// Closes the database connection.
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
