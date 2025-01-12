import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lisiecka_aplikacje_mobilne/data/note_database.dart';
import 'package:lisiecka_aplikacje_mobilne/data/models/note_model.dart';
import 'package:lisiecka_aplikacje_mobilne/utils/my_colors.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Note> notes = [];
  int? userId;

  @override
  void initState() {
    super.initState();
    _initializeHome();
  }

  Future<void> _initializeHome() async {
    await _loadCurrentUser();
    if (userId != null) {
      await _loadNotes();
    }
  }

  Future<void> _loadCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('userId'); // Pobranie ID użytkownika jako int
    });
  }

  Future<void> _loadNotes() async {
    if (userId == null) return;

    final dbNotes = await NoteDatabase.instance.getNotesForUser(userId!);
    setState(() {
      notes = dbNotes;
    });
  }

  Future<void> _addNote(String title, String content) async {
    if (userId == null) return;

    final note = Note(
      title: title,
      content: content,
      date: DateTime.now().toLocal().toString().split('.')[0], // Data utworzenia w formacie "yyyy-MM-dd HH:mm:ss"
      userId: userId!,
    );
    await NoteDatabase.instance.addNote(note);
    await _loadNotes();
  }

  Future<void> _editNote(Note note, String newTitle, String newContent) async {
    final updatedNote = note.copyWith(
      title: newTitle,
      content: newContent,
      date: DateTime.now().toLocal().toString().split('.')[0], // Aktualizacja daty modyfikacji
    );
    await NoteDatabase.instance.updateNote(updatedNote);
    await _loadNotes();
  }

  Future<void> _deleteNote(Note note) async {
    await NoteDatabase.instance.deleteNoteById(note.id!);
    await _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        backgroundColor: MyColors.purpleColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: notes.isEmpty
            ? const Center(child: Text('No notes available. Add one!'))
            : ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: notes.length,
          itemBuilder: (context, index) {
            final note = notes[index];
            return ListTile(
              title: Text(note.title),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(note.content),
                  Text(
                    'Last Modified: ${note.date}',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _showEditNoteDialog(context, note),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteNoteConfirmation(context, note),
                  ),
                ],
              ),
            );
          },
        ),
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

  void _showEditNoteDialog(BuildContext context, Note note) {
    final titleController = TextEditingController(text: note.title);
    final contentController = TextEditingController(text: note.content);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Note'),
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
                _editNote(
                  note,
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

  void _deleteNoteConfirmation(BuildContext context, Note note) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Note'),
          content: const Text('Are you sure you want to delete this note?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteNote(note);
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('userId');
    Navigator.pushReplacementNamed(context, '/login');
  }
}
