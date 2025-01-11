import 'package:flutter/material.dart';
import 'package:lisiecka_aplikacje_mobilne/data/models/note_model.dart'; // Import modelu
import 'package:lisiecka_aplikacje_mobilne/data/note_database.dart'; // Import bazy danych
import 'package:lisiecka_aplikacje_mobilne/utils/my_colors.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Note> notes = [];
  String? userId; // Przechowujemy ID użytkownika

  @override
  void initState() {
    super.initState();
    _loadUserAndNotes();
  }

  Future<void> _loadUserAndNotes() async {
    // Odczytaj userId z SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId');

    // Jeśli userId jest null, wyloguj użytkownika
    if (userId == null) {
      _logout();
      return;
    }

    // Załaduj notatki użytkownika
    final dbNotes = await NoteDatabase.instance.readNotesByUser(userId!);
    setState(() {
      notes = dbNotes;
    });
  }

  Future<void> _addNote(String title, String content) async {
    if (userId == null) return; // Nie rób nic, jeśli userId jest null
    final note = Note(
      title: title,
      content: content,
      date: DateTime.now().toIso8601String(),
      userId: userId!, // Przypisz userId do notatki
    );
    await NoteDatabase.instance.create(note);
    _loadUserAndNotes();
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Wyczyszczenie zapisanych danych
    Navigator.pushReplacementNamed(context, '/login'); // Przekierowanie do ekranu logowania
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        backgroundColor: MyColors.purpleColor,
        actions: [
          IconButton(
            onPressed: _logout, // Wylogowanie użytkownika
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: notes.isEmpty
          ? const Center(
        child: Text('No notes yet'),
      )
          : ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          return ListTile(
            title: Text(note.title),
            subtitle: Text(note.content),
            trailing: Text(note.date.split('T').first),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddNoteDialog(context);
        },
        backgroundColor: MyColors.purpleColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddNoteDialog(BuildContext context) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('New Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(labelText: 'Content'),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _addNote(
                  titleController.text,
                  contentController.text,
                );
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
