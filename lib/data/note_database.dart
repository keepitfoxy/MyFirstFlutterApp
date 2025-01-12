import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class NoteDatabase {
  static final NoteDatabase instance = NoteDatabase._init();
  static Database? _database;

  NoteDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        userId INTEGER NOT NULL,
        FOREIGN KEY (userId) REFERENCES users (id)
      )
    ''');
  }

  Future<int?> authenticateUser(String username, String password) async {
    final db = await instance.database;
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    return result.isNotEmpty ? result.first['id'] as int : null;
  }

  Future<int> addUser(String username, String password) async {
    final db = await instance.database;
    return await db.insert('users', {'username': username, 'password': password});
  }

  Future<void> addNote(String title, String content, int userId) async {
    final db = await instance.database;
    await db.insert('notes', {
      'title': title,
      'content': content,
      'userId': userId,
    });
  }

  Future<List<Map<String, dynamic>>> getNotesForUser(int userId) async {
    final db = await instance.database;
    return await db.query(
      'notes',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'id DESC',
    );
  }
  Future<void> initializeTestData() async {
    final db = await instance.database;

    // Dodaj przykładowych użytkowników
    await db.insert('users', {'username': 'test1', 'password': 'password1'});
    await db.insert('users', {'username': 'test2', 'password': 'password2'});

    // Pobierz ID użytkownika "test1"
    final result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: ['test1'],
    );
    final userId = result.first['id'] as int;

    // Dodaj przykładowe notatki dla użytkownika "test1"
    await db.insert('notes', {
      'title': 'Sample Note 1',
      'content': 'This is the first sample note.',
      'userId': userId,
    });
    await db.insert('notes', {
      'title': 'Sample Note 2',
      'content': 'This is the second sample note.',
      'userId': userId,
    });
  }
}
