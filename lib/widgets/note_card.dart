import 'package:flutter/material.dart';
import '../models/note.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;

  const NoteCard({
    Key? key,
    required this.note,
    required this.onTap,
  }) : super(key: key);

  Color _getColor() {
    return Color(int.parse(note.color));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _getColor(),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (note.title.isNotEmpty)
                Text(
                  note.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              if (note.title.isNotEmpty) const SizedBox(height: 8),
              Text(
                note.content,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}