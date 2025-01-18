class Note {
  final String? id; // przechowywanie unikalnego identyfikatora notatki
  final String title; // przechowywanie tytułu notatki
  final String content; // przechowywanie zawartości notatki
  final String date; // przechowywanie daty utworzenia/modyfikacji notatki
  final int userId; // przechowywanie identyfikatora użytkownika

  Note({
    this.id, // opcjonalne pole dla id (może być null, gdy tworzymy nową notatkę)
    required this.title, // wymagany tytuł
    required this.content, // wymagana zawartość
    required this.date, // wymagana data
    required this.userId, // wymagany identyfikator użytkownika
  });

  // konwersja obiektu Note na mapę danych (np. do zapisu w bazie danych)
  Map<String, dynamic> toMap() {
    return {
      'id': id, // zapis id
      'title': title, // zapis tytułu
      'content': content, // zapis zawartości
      'date': date, // zapis daty
      'userId': userId, // zapis identyfikatora użytkownika
    };
  }

  // tworzenie obiektu Note z mapy danych (np. podczas odczytu z bazy danych)
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as String?, // odczyt id
      title: map['title'] as String, // odczyt tytułu
      content: map['content'] as String, // odczyt zawartości
      date: map['date'] as String, // odczyt daty
      userId: map['userId'] as int, // odczyt identyfikatora użytkownika
    );
  }

  // tworzenie kopii obiektu Note z opcjonalnymi zmianami w wybranych polach
  Note copyWith({
    String? id, // możliwość zmiany id
    String? title, // możliwość zmiany tytułu
    String? content, // możliwość zmiany zawartości
    String? date, // możliwość zmiany daty
    int? userId, // możliwość zmiany identyfikatora użytkownika
  }) {
    return Note(
      id: id ?? this.id, // użycie nowego lub obecnego id
      title: title ?? this.title, // użycie nowego lub obecnego tytułu
      content: content ?? this.content, // użycie nowej lub obecnej zawartości
      date: date ?? this.date, // użycie nowej lub obecnej daty
      userId: userId ?? this.userId, // użycie nowego lub obecnego identyfikatora użytkownika
    );
  }
}
