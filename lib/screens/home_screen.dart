import 'package:flutter/material.dart';
import '../models/note.dart';
import '../services/storage_service.dart';
import '../widgets/note_card.dart';
import 'note_editor.dart';

class HomeScreen extends StatefulWidget {
  final StorageService storageService;

  const HomeScreen({Key? key, required this.storageService}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Note> _notes = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final notes = await widget.storageService.getNotes();
    setState(() {
      _notes = notes;
    });
  }

  List<Note> get _filteredNotes {
    return _notes.where((note) {
      final query = _searchQuery.toLowerCase();
      return note.title.toLowerCase().contains(query) ||
          note.content.toLowerCase().contains(query);
    }).toList();
  }

  List<Note> get _pinnedNotes {
    return _filteredNotes.where((note) => note.isPinned).toList();
  }

  List<Note> get _unpinnedNotes {
    return _filteredNotes.where((note) => !note.isPinned).toList();
  }

  Future<void> _saveNote(Note note) async {
    setState(() {
      final index = _notes.indexWhere((n) => n.id == note.id);
      if (index >= 0) {
        _notes[index] = note;
      } else {
        _notes.add(note);
      }
    });
    await widget.storageService.saveNotes(_notes);
  }

  void _openNoteEditor([Note? note]) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteEditor(
          note: note,
          onSave: _saveNote,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
          decoration: const InputDecoration(
            hintText: 'Search your notes',
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          if (_pinnedNotes.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('PINNED'),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _pinnedNotes.length,
              itemBuilder: (context, index) {
                final note = _pinnedNotes[index];
                return NoteCard(
                  note: note,
                  onTap: () => _openNoteEditor(note),
                );
              },
            ),
            const Divider(),
          ],
          if (_unpinnedNotes.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('OTHERS'),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _unpinnedNotes.length,
              itemBuilder: (context, index) {
                final note = _unpinnedNotes[index];
                return NoteCard(
                  note: note,
                  onTap: () => _openNoteEditor(note),
                );
              },
            ),
          ],
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openNoteEditor(),
        child: const Icon(Icons.add),
      ),
    );
  }
}