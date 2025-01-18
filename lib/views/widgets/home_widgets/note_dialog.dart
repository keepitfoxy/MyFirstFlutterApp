import 'package:flutter/material.dart';

class NoteDialog extends StatelessWidget {
  final String title; // tytuł dialogu
  final TextEditingController titleController; // kontroler dla pola tytułu
  final TextEditingController contentController; // kontroler dla pola treści

  const NoteDialog({
    required this.title,
    required this.titleController,
    required this.contentController,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title), // wyświetlenie tytułu dialogu
      content: Column(
        mainAxisSize: MainAxisSize.min, // minimalna wielkość kolumny
        children: [
          TextField(
            controller: titleController, // pole tekstowe dla tytułu
            decoration: const InputDecoration(labelText: 'Title'), // etykieta dla pola
          ),
          TextField(
            controller: contentController, // pole tekstowe dla treści
            decoration: const InputDecoration(labelText: 'Content'), // etykieta dla pola
            maxLines: 3, // maksymalna liczba linii w polu tekstowym
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false), // zamknięcie dialogu bez zapisu
          child: const Text('Cancel'), // etykieta przycisku "Cancel"
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true), // zamknięcie dialogu i potwierdzenie akcji
          child: const Text('Save'), // etykieta przycisku "Save"
        ),
      ],
    );
  }
}
