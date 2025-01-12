class Note {
  final int? id;
  final String title;
  final String content;
  final String date;
  final int userId; // userId jako int

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date,
      'userId': userId,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as int?,
      title: map['title'] as String,
      content: map['content'] as String,
      date: map['date'] as String,
      userId: map['userId'] as int,
    );
  }

  Note copyWith({
    int? id,
    String? title,
    String? content,
    String? date,
    int? userId, // userId jako int
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      date: date ?? this.date,
      userId: userId ?? this.userId,
    );
  }
}
