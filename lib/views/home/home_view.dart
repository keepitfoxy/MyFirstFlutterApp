import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lisiecka_aplikacje_mobilne/data/models/note_model.dart';
import 'package:lisiecka_aplikacje_mobilne/utils/my_colors.dart';
import 'package:lisiecka_aplikacje_mobilne/views/widgets/home_widgets/note_dialog.dart';
import 'package:lisiecka_aplikacje_mobilne/views/widgets/home_widgets/note_list.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Note> notes = []; // przechowywanie listy notatek
  int? userId; // identyfikator użytkownika
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref('notes'); // referencja do Firebase Realtime Database

  @override
  void initState() {
    super.initState();
    _initializeHome(); // inicjalizacja widoku głównego
  }

  // inicjalizacja danych w widoku głównym
  Future<void> _initializeHome() async {
    await _loadCurrentUser(); // załadowanie aktualnego użytkownika
    if (userId != null) {
      await _loadNotes(); // załadowanie notatek użytkownika
    }
  }

  // załadowanie danych użytkownika z SharedPreferences
  Future<void> _loadCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('userId'); // przypisanie ID użytkownika
    });
  }

  // załadowanie notatek użytkownika z Firebase
  Future<void> _loadNotes() async {
    if (userId == null) return;

    final userNotesRef = _databaseReference.child('user_${userId.toString()}'); // odniesienie do notatek użytkownika
    userNotesRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        setState(() {
          notes = data.entries.map((entry) {
            final noteData = entry.value as Map<dynamic, dynamic>?;
            if (noteData != null) {
              return Note.fromMap(Map<String, dynamic>.from(noteData)); // konwersja danych na obiekt Note
            }
            return null;
          }).whereType<Note>().toList(); // filtrowanie prawidłowych notatek
        });
      } else {
        setState(() {
          notes = []; // czyszczenie listy notatek, jeśli brak danych
        });
      }
    });
  }

  // otwieranie okna dialogowego do dodania notatki
  Future<void> _addNoteDialog(BuildContext context) async {
    final titleController = TextEditingController(); // kontroler pola tytułu
    final contentController = TextEditingController(); // kontroler pola treści

    final result = await showDialog(
      context: context,
      builder: (context) => NoteDialog(
        title: 'New Note', // tytuł okna dialogowego
        titleController: titleController,
        contentController: contentController,
      ),
    );

    if (result == true) {
      await _addNote(titleController.text, contentController.text); // dodanie nowej notatki
    }
  }

  // dodanie nowej notatki do Firebase
  Future<void> _addNote(String title, String content) async {
    if (userId == null) return;

    final newNoteRef = _databaseReference.child('user_${userId.toString()}').push(); // tworzenie nowego wpisu w Firebase
    final note = Note(
      id: newNoteRef.key, // przypisanie unikalnego klucza
      title: title,
      content: content,
      date: DateTime.now().toLocal().toString().split('.')[0], // aktualna data
      userId: userId!,
    );
    await newNoteRef.set(note.toMap()); // zapis notatki w Firebase
  }

  // otwieranie okna dialogowego do edycji notatki
  Future<void> _editNoteDialog(BuildContext context, Note note) async {
    final titleController = TextEditingController(text: note.title); // kontroler pola tytułu z aktualnymi danymi
    final contentController = TextEditingController(text: note.content); // kontroler pola treści z aktualnymi danymi

    final result = await showDialog(
      context: context,
      builder: (context) => NoteDialog(
        title: 'Edit Note', // tytuł okna dialogowego
        titleController: titleController,
        contentController: contentController,
      ),
    );

    if (result == true) {
      await _editNote(note, titleController.text, contentController.text); // edycja notatki
    }
  }

  // aktualizacja istniejącej notatki w Firebase
  Future<void> _editNote(Note note, String newTitle, String newContent) async {
    if (userId == null || note.id == null) return;

    final updatedNote = note.copyWith(
      title: newTitle,
      content: newContent,
      date: DateTime.now().toLocal().toString().split('.')[0], // aktualizacja daty
    );

    await _databaseReference
        .child('user_${userId.toString()}')
        .child(note.id!)
        .set(updatedNote.toMap()); // zapis zaktualizowanej notatki
  }

  // otwieranie okna dialogowego potwierdzenia usunięcia notatki
  Future<void> _deleteNoteConfirmation(BuildContext context, Note note) async {
    final result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note'), // tytuł dialogu
        content: const Text('Are you sure you want to delete this note?'), // treść dialogu
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), // anulowanie
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true), // potwierdzenie
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (result == true) {
      await _deleteNote(note); // usunięcie notatki
    }
  }

  // usunięcie notatki z Firebase
  Future<void> _deleteNote(Note note) async {
    if (userId == null || note.id == null) return;

    await _databaseReference
        .child('user_${userId.toString()}')
        .child(note.id!)
        .remove(); // usunięcie notatki z Firebase
  }

  // wylogowanie użytkownika
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn'); // usunięcie stanu zalogowania
    await prefs.remove('userId'); // usunięcie ID użytkownika
    Navigator.pushReplacementNamed(context, '/login'); // nawigacja do ekranu logowania
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.purpleColor, // kolor paska aplikacji
        title: const Text(
          'My Notes', // tytuł widoku
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        centerTitle: true, // wyśrodkowanie tytułu
        elevation: 0, // brak cienia
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white), // ikonka wylogowania
            onPressed: _logout, // obsługa wylogowania
          ),
        ],
      ),
      body: notes.isEmpty
          ? const Center(child: Text('No notes available. Add one!')) // komunikat, gdy brak notatek
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10), // odstępy po bokach
          child: Column(
            children: [
              NoteList(
                notes: notes, // lista notatek
                onEdit: _editNoteDialog, // funkcja edycji
                onDelete: _deleteNoteConfirmation, // funkcja usuwania
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNoteDialog(context), // otwieranie dialogu dodawania notatki
        backgroundColor: MyColors.lilacColor, // kolor przycisku
        child: const Icon(Icons.add), // ikonka dodawania
      ),
    );
  }
}
