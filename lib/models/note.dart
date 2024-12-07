import 'dart:convert';

class Note {
  final String id;
  final String title;
  final String content;
  final String color;
  final bool isPinned;
  final DateTime createdAt;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.color,
    this.isPinned = false,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'color': color,
      'isPinned': isPinned,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      color: json['color'],
      isPinned: json['isPinned'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}