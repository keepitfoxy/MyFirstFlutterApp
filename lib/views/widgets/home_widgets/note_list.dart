import 'package:flutter/material.dart';
import 'package:lisiecka_aplikacje_mobilne/data/models/note_model.dart';
import 'package:lisiecka_aplikacje_mobilne/utils/my_colors.dart';

class NoteList extends StatefulWidget {
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
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  Map<int, bool> expandedNotes = {}; // Przechowuje stan rozwinięcia notatek

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10), // Odstępy po bokach
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.notes.length,
        itemBuilder: (context, index) {
          final note = widget.notes[index];
          final isExpanded = expandedNotes[index] ?? false;

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 8), // Przerwa między notatkami
            padding: const EdgeInsets.all(12), // Padding wewnątrz notatki
            decoration: BoxDecoration(
              color: Colors.white, // Białe tło notatki
              border: Border.all(color: MyColors.lilacColor, width: 2), // Obramowanie
              borderRadius: BorderRadius.circular(15), // Zaokrąglenie rogów
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      expandedNotes[index] = !isExpanded; // Przełącz stan
                    });
                  },
                  child: Text(
                    note.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: MyColors.purpleColor,
                    ),
                  ),
                ),
                if (isExpanded) ...[
                  const SizedBox(height: 8), // Odstęp między tytułem a zawartością
                  Text(
                    note.content,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Last Modified: ${note.date}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => widget.onEdit(context, note), // Wywołuje `_editNoteDialog`
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => widget.onDelete(context, note),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
