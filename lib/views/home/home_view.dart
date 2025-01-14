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

  Future<void> _loadNotes() async {
    if (userId == null) return;

    final userNotesRef = _databaseReference.child('user_${userId.toString()}');
    userNotesRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        setState(() {
          notes = data.entries.map((entry) {
            final noteData = entry.value as Map<dynamic, dynamic>?;
            if (noteData != null) {
              return Note.fromMap(Map<String, dynamic>.from(noteData));
            }
            return null;
          }).whereType<Note>().toList();
        });
      } else {
        setState(() {
          notes = [];
        });
      }
    });
  }

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

    final newNoteRef = _databaseReference.child('user_${userId.toString()}').push();
    final note = Note(
      id: newNoteRef.key,
      title: title,
      content: content,
      date: DateTime.now().toLocal().toString().split('.')[0],
      userId: userId!,
    );
    await newNoteRef.set(note.toMap());
  }

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
        .child(note.id!)
        .set(updatedNote.toMap());
  }

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
        .child(note.id!)
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
        backgroundColor: MyColors.purpleColor,
        title: const Text(
          'My Notes',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _logout,
          ),
        ],
      ),
      body: notes.isEmpty
          ? const Center(child: Text('No notes available. Add one!'))
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              NoteList(
                notes: notes,
                onEdit: _editNoteDialog,
                onDelete: _deleteNoteConfirmation,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNoteDialog(context),
        backgroundColor: MyColors.lilacColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
