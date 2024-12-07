import 'package:flutter/material.dart';
import '../models/note.dart';

class NoteEditor extends StatefulWidget {
  final Note? note;
  final Function(Note) onSave;

  const NoteEditor({
    Key? key,
    this.note,
    required this.onSave,
  }) : super(key: key);

  @override
  _NoteEditorState createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late String _selectedColor;
  late bool _isPinned;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(text: widget.note?.content ?? '');
    _selectedColor = widget.note?.color ?? Colors.white.value.toString();
    _isPinned = widget.note?.isPinned ?? false;
  }

  void _saveNote() {
    final note = Note(
      id: widget.note?.id ?? DateTime.now().toString(),
      title: _titleController.text,
      content: _contentController.text,
      color: _selectedColor,
      isPinned: _isPinned,
      createdAt: widget.note?.createdAt ?? DateTime.now(),
    );
    widget.onSave(note);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(_isPinned ? Icons.push_pin : Icons.push_pin_outlined),
            onPressed: () {
              setState(() {
                _isPinned = !_isPinned;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Title',
                border: InputBorder.none,
              ),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Expanded(
              child: TextField(
                controller: _contentController,
                decoration: const InputDecoration(
                  hintText: 'Note',
                  border: InputBorder.none,
                ),
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}