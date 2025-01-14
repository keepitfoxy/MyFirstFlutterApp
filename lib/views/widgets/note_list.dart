import 'package:flutter/material.dart';
import 'package:lisiecka_aplikacje_mobilne/data/models/note_model.dart';

class NoteList extends StatelessWidget {
  final List<Note> notes;
  final Function(BuildContext, Note) onEdit;
  final Function(BuildContext, Note) onDelete;

  const NoteList({
    required this.notes,
    required this.onEdit,
    required this.onDelete,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
                onPressed: () => onEdit(context, note),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => onDelete(context, note),
              ),
            ],
          ),
        );
      },
    );
  }
}
