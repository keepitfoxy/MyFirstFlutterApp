import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      userId = prefs.getInt('userId'); // Poprawiono, by obsługiwać dynamic jako int
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
            final noteData = Map<String, dynamic>.from(entry.value as Map);
            final noteKey = int.tryParse(entry.key.toString()) ?? entry.key.hashCode;
            // Konwersja na int lub użycie hashCode jako unikalnego identyfikatora
            return Note.fromMap(noteData).copyWith(id: noteKey);
          }).toList();
        });
      }
    });
  }


  Future<void> _addNote(String title, String content) async {
    if (userId == null) return;

    final note = Note(
      title: title,
      content: content,
      date: DateTime.now().toLocal().toString().split('.')[0], // Data w formacie "yyyy-MM-dd HH:mm:ss"
      userId: userId!,
    );

    await _databaseReference.child('user_${userId.toString()}').push().set(note.toMap());
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

  Future<void> _deleteNote(Note note) async {
    if (userId == null || note.id == null) return;

    await _databaseReference
        .child('user_${userId.toString()}')
        .child(note.id! as String)
        .remove();
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
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
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
