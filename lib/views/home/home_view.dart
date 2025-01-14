import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lisiecka_aplikacje_mobilne/data/models/note_model.dart';
import 'package:lisiecka_aplikacje_mobilne/utils/my_colors.dart';
import 'package:lisiecka_aplikacje_mobilne/views/widgets/note_dialog.dart';
import 'package:lisiecka_aplikacje_mobilne/views/widgets/note_list.dart';


class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Note> notes = [];
  int? userId;
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref('notes');

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
      userId = prefs.getInt('userId');
    });
  }

  // READ: Pobieranie notatek dla użytkownika
  Future<void> _loadNotes() async {
    if (userId == null) return;

    final userNotesRef = _databaseReference.child('user_${userId.toString()}');
    userNotesRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        setState(() {
          notes = data.entries.map((entry) {
            final noteData = Map<String, dynamic>.from(entry.value as Map);
            final noteKey = int.tryParse(entry.key.toString()) ?? entry.key.hashCode;
            return Note.fromMap(noteData).copyWith(id: noteKey);
          }).toList();
        });
      }
    });
  }

  // CREATE: Dodawanie nowej notatki
  Future<void> _addNoteDialog(BuildContext context) async {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    final result = await showDialog(
      context: context,
      builder: (context) => NoteDialog(
        title: 'New Note',
        titleController: titleController,
        contentController: contentController,
      ),
    );

    if (result == true) {
      await _addNote(titleController.text, contentController.text);
    }
  }

  Future<void> _addNote(String title, String content) async {
    if (userId == null) return;

    final note = Note(
      title: title,
      content: content,
      date: DateTime.now().toLocal().toString().split('.')[0],
      userId: userId!,
    );

    await _databaseReference.child('user_${userId.toString()}').push().set(note.toMap());
  }

  // UPDATE: Edycja istniejącej notatki
  Future<void> _editNoteDialog(BuildContext context, Note note) async {
    final titleController = TextEditingController(text: note.title);
    final contentController = TextEditingController(text: note.content);

    final result = await showDialog(
      context: context,
      builder: (context) => NoteDialog(
        title: 'Edit Note',
        titleController: titleController,
        contentController: contentController,
      ),
    );

    if (result == true) {
      await _editNote(note, titleController.text, contentController.text);
    }
  }

  Future<void> _editNote(Note note, String newTitle, String newContent) async {
    if (userId == null || note.id == null) return;

    final updatedNote = note.copyWith(
      title: newTitle,
      content: newContent,
      date: DateTime.now().toLocal().toString().split('.')[0],
    );

    await _databaseReference
        .child('user_${userId.toString()}')
        .child(note.id! as String)
        .update(updatedNote.toMap());
  }

  // DELETE: Usuwanie notatki
  Future<void> _deleteNoteConfirmation(BuildContext context, Note note) async {
    final result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note'),
        content: const Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (result == true) {
      await _deleteNote(note);
    }
  }

  Future<void> _deleteNote(Note note) async {
    if (userId == null || note.id == null) return;

    await _databaseReference
        .child('user_${userId.toString()}')
        .child(note.id! as String)
        .remove();
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('userId');
    Navigator.pushReplacementNamed(context, '/login');
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
      body: notes.isEmpty
          ? const Center(child: Text('No notes available. Add one!'))
          : NoteList(
        notes: notes,
        onEdit: _editNoteDialog,
        onDelete: _deleteNoteConfirmation,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNoteDialog(context),
        backgroundColor: MyColors.purpleColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}