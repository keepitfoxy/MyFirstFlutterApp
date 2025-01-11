import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:lisiecka_aplikacje_mobilne/data/models/note_model.dart';

class NoteDatabase {
  static final NoteDatabase instance = NoteDatabase._init();
  static Database? _database;

  NoteDatabase._init();

  // Getter do uzyskania dostępu do bazy danych
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes.db');
    return _database!;
  }

  // Inicjalizacja bazy danych
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  // Tworzenie tabeli w bazie danych
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        date TEXT NOT NULL,
        userId TEXT NOT NULL
      )
    ''');
  }

  // Tworzenie nowej notatki w bazie danych
  Future<Note> create(Note note) async {
    final db = await instance.database;
    final id = await db.insert('notes', note.toMap());
    return note.copyWith(id: id); // Zwracamy obiekt z nowym id
  }

  // Odczytanie wszystkich notatek dla konkretnego użytkownika
  Future<List<Note>> readNotesByUser(String userId) async {
    final db = await instance.database;
    final result = await db.query(
      'notes',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'id DESC',
    );

    return result.map((map) => Note.fromMap(map)).toList();
  }

  // Zamknięcie bazy danych
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
