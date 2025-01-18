import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:lisiecka_aplikacje_mobilne/data/models/note_model.dart';

class NoteDatabase {
  static final NoteDatabase instance = NoteDatabase._init(); // inicjalizacja singletonu
  static Database? _database; // przechowywanie instancji bazy danych

  NoteDatabase._init(); // konstruktor prywatny do obsługi singletonu

  // uzyskanie instancji bazy danych
  Future<Database> get database async {
    if (_database != null) return _database!; // jeśli baza istnieje, zwraca ją
    _database = await _initDB('notes.db'); // jeśli nie, inicjalizuje nową bazę
    return _database!;
  }

  // inicjalizacja bazy danych
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath(); // ścieżka do bazy danych
    final path = join(dbPath, filePath); // łączenie ścieżki z nazwą pliku

    return await openDatabase(
      path, // otwarcie bazy danych
      version: 1, // wersja bazy danych
      onCreate: _createDB, // tworzenie tabel przy pierwszym uruchomieniu
    );
  }

  // tworzenie tabel w bazie danych
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT, -- id notatki
        title TEXT NOT NULL, -- tytuł notatki
        content TEXT NOT NULL, -- treść notatki
        date TEXT NOT NULL, -- data utworzenia
        userId INTEGER NOT NULL -- identyfikator użytkownika
      )
    ''');

    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT, -- id użytkownika
        username TEXT NOT NULL, -- nazwa użytkownika
        password TEXT NOT NULL -- hasło użytkownika
      )
    ''');
  }

  // autoryzacja użytkownika
  Future<int?> authenticateUser(String username, String password) async {
    final db = await instance.database; // uzyskanie bazy danych
    final result = await db.query(
      'users', // tabela użytkowników
      where: 'username = ? AND password = ?', // warunek logowania
      whereArgs: [username, password], // dane logowania
    );

    return result.isNotEmpty ? result.first['id'] as int : null; // zwraca id użytkownika lub null
  }

  // dodanie użytkownika do bazy danych
  Future<int> addUser(String username, String password) async {
    final db = await instance.database; // uzyskanie bazy danych
    return await db.insert('users', {'username': username, 'password': password}); // zapis użytkownika
  }

  // dodanie notatki do bazy danych
  Future<void> addNote(Note note) async {
    final db = await instance.database; // uzyskanie bazy danych
    await db.insert('notes', note.toMap()); // zapis notatki
  }

  // pobranie wszystkich notatek dla danego użytkownika
  Future<List<Note>> getNotesForUser(int userId) async {
    final db = await instance.database; // uzyskanie bazy danych
    final result = await db.query(
      'notes', // tabela notatek
      where: 'userId = ?', // warunek filtrowania po id użytkownika
      whereArgs: [userId], // id użytkownika
      orderBy: 'id DESC', // sortowanie malejąco według id
    );
    return result.map((json) => Note.fromMap(json)).toList(); // konwersja wyników na listę obiektów Note
  }

  // aktualizacja istniejącej notatki
  Future<void> updateNote(Note note) async {
    final db = await instance.database; // uzyskanie bazy danych
    await db.update(
      'notes', // tabela notatek
      note.toMap(), // dane do aktualizacji
      where: 'id = ?', // warunek po id notatki
      whereArgs: [note.id], // id notatki
    );
  }

  // inicjalizacja przykładowych danych w bazie
  Future<void> initializeTestData() async {
    final db = await instance.database; // uzyskanie bazy danych

    // dodanie przykładowych użytkowników
    await db.insert('users', {'username': 'test1', 'password': 'password1'});
    await db.insert('users', {'username': 'test2', 'password': 'password2'});

    // pobranie id użytkownika "test1"
    final result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: ['test1'],
    );
    final userId = result.first['id'] as int;

    // dodanie przykładowych notatek dla użytkownika "test1"
    await db.insert('notes', {
      'title': 'Sample Note 1',
      'content': 'This is the first sample note.',
      'date': DateTime.now().toIso8601String(), // data utworzenia
      'userId': userId,
    });
    await db.insert('notes', {
      'title': 'Sample Note 2',
      'content': 'This is the second sample note.',
      'date': DateTime.now().toIso8601String(), // data utworzenia
      'userId': userId,
    });
  }

  // usuwanie notatki po id
  Future<void> deleteNoteById(int id) async {
    final db = await instance.database; // uzyskanie bazy danych

    await db.delete(
      'notes', // tabela notatek
      where: 'id = ?', // warunek po id notatki
      whereArgs: [id], // id notatki
    );
  }
}
