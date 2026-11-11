import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance =
      DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  // Get database instance
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDB('eco_app.db');
    return _database!;
  }

  // Initialize database
  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onConfigure: (db) async {
        await db.execute(
          'PRAGMA foreign_keys = ON',
        );
      },
      onCreate: _createDB,
    );
  }

  // Create tables
  Future<void> _createDB(
    Database db,
    int version,
  ) async {
    // Users table
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    // Complaints table
    await db.execute('''
      CREATE TABLE complaints (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        category TEXT NOT NULL,
        location TEXT NOT NULL,
        description TEXT NOT NULL,
        status TEXT NOT NULL DEFAULT 'Submitted',
        created_at TEXT NOT NULL,
        FOREIGN KEY (user_id)
          REFERENCES users (id)
          ON DELETE CASCADE
      )
    ''');

    // Notifications table
    await db.execute('''
      CREATE TABLE notifications (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        message TEXT NOT NULL,
        is_read INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        FOREIGN KEY (user_id)
          REFERENCES users (id)
          ON DELETE CASCADE
      )
    ''');
  }

  // =========================
  // USER OPERATIONS
  // =========================

  // Register user
  Future<int> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    final db = await database;

    return await db.insert(
      'users',
      {
        'name': name,
        'email': email,
        'password': password,
        'created_at':
            DateTime.now().toIso8601String(),
      },
    );
  }

  // Get user by email
  Future<Map<String, dynamic>?> getUserByEmail(
    String email,
  ) async {
    final db = await database;

    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first;
    }

    return null;
  }

  // =========================
  // COMPLAINT OPERATIONS
  // =========================

  // Add complaint
  Future<int> addComplaint({
    required int userId,
    required String title,
    required String category,
    required String location,
    required String description,
  }) async {
    final db = await database;

    return await db.insert(
      'complaints',
      {
        'user_id': userId,
        'title': title,
        'category': category,
        'location': location,
        'description': description,
        'status': 'Submitted',
        'created_at':
            DateTime.now().toIso8601String(),
      },
    );
  }

  // Get complaints for a specific user
  Future<List<Map<String, dynamic>>>
      getComplaintsByUser(int userId) async {
    final db = await database;

    return await db.query(
      'complaints',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );
  }

  // Get total complaints for a user
  Future<int> getComplaintCount(
    int userId,
  ) async {
    final db = await database;

    final result = await db.rawQuery(
      '''
      SELECT COUNT(*) AS count
      FROM complaints
      WHERE user_id = ?
      ''',
      [userId],
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  // =========================
  // NOTIFICATION OPERATIONS
  // =========================

  // Add notification
  Future<int> addNotification({
    required int userId,
    required String title,
    required String message,
  }) async {
    final db = await database;

    return await db.insert(
      'notifications',
      {
        'user_id': userId,
        'title': title,
        'message': message,
        'is_read': 0,
        'created_at':
            DateTime.now().toIso8601String(),
      },
    );
  }

  // Get notifications for a user
  Future<List<Map<String, dynamic>>>
      getNotificationsByUser(int userId) async {
    final db = await database;

    return await db.query(
      'notifications',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );
  }

  // Mark notification as read
  Future<int> markNotificationAsRead(
    int notificationId,
  ) async {
    final db = await database;

    return await db.update(
      'notifications',
      {
        'is_read': 1,
      },
      where: 'id = ?',
      whereArgs: [notificationId],
    );
  }

  // Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}