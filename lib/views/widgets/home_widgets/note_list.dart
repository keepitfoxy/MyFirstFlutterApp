import 'package:flutter/material.dart';
import 'package:lisiecka_aplikacje_mobilne/data/models/note_model.dart';
import 'package:lisiecka_aplikacje_mobilne/utils/my_colors.dart';

class NoteList extends StatefulWidget {
  final List<Note> notes; // lista notatek
  final Function(BuildContext, Note) onEdit; // funkcja wywoływana przy edycji
  final Function(BuildContext, Note) onDelete; // funkcja wywoływana przy usuwaniu

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
  Map<int, bool> expandedNotes = {}; // przechowuje stan rozwinięcia notatek

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10), // odstępy po bokach
      child: ListView.builder(
        shrinkWrap: true, // pozwala na dynamiczne dopasowanie listy
        physics: const NeverScrollableScrollPhysics(), // wyłączenie przewijania
        itemCount: widget.notes.length, // liczba elementów na liście
        itemBuilder: (context, index) {
          final note = widget.notes[index]; // aktualna notatka
          final isExpanded = expandedNotes[index] ?? false; // stan rozwinięcia notatki

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 8), // przerwa między notatkami
            padding: const EdgeInsets.all(12), // padding wewnątrz notatki
            decoration: BoxDecoration(
              color: Colors.white, // białe tło notatki
              border: Border.all(color: MyColors.lilacColor, width: 2), // obramowanie
              borderRadius: BorderRadius.circular(15), // zaokrąglenie rogów
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      expandedNotes[index] = !isExpanded; // przełączanie stanu rozwinięcia
                    });
                  },
                  child: Text(
                    note.title, // tytuł notatki
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: MyColors.purpleColor,
                    ),
                  ),
                ),
                if (isExpanded) ...[
                  const SizedBox(height: 8), // odstęp między tytułem a zawartością
                  Text(
                    note.content, // treść notatki
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Last Modified: ${note.date}', // data ostatniej modyfikacji
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end, // przyciski po prawej stronie
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue), // ikona edycji
                        onPressed: () => widget.onEdit(context, note), // wywołanie funkcji edycji
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red), // ikona usuwania
                        onPressed: () => widget.onDelete(context, note), // wywołanie funkcji usuwania
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
