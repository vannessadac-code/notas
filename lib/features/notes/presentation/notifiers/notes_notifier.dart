import 'package:flutter/foundation.dart';
import 'package:notesapp/features/notes/domain/entities/note.dart';
import 'package:notesapp/features/notes/domain/usecases/create_note_use_case.dart';
import 'package:notesapp/features/notes/domain/usecases/delete_note_use_case.dart';
import 'package:notesapp/features/notes/domain/usecases/list_notes_use_case.dart';
import 'package:notesapp/features/notes/domain/usecases/update_note_use_case.dart';

class NotesNotifier extends ChangeNotifier {
  final CreateNoteUseCase _createNote;
  final UpdateNoteUseCase _updateNote;
  final DeleteNoteUseCase _deleteNote;
  final ListNotesUseCase _listNotes;

  List<Note> _notes = [];
  bool _isLoading = false;
  String? _error;

  List<Note> get notes => _notes;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<Note> get pinnedNotes => _notes.where((n) => n.isPinned).toList();
  List<Note> get unpinnedNotes => _notes.where((n) => !n.isPinned).toList();

  NotesNotifier({
    required CreateNoteUseCase createNoteUseCase,
    required UpdateNoteUseCase updateNoteUseCase,
    required DeleteNoteUseCase deleteNoteUseCase,
    required ListNotesUseCase listNotesUseCase,
  }) : _createNote = createNoteUseCase,
       _updateNote = updateNoteUseCase,
       _deleteNote = deleteNoteUseCase,
       _listNotes = listNotesUseCase;

  Future<void> loadNotes({Map<String, dynamic>? filters}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _notes = await _listNotes.execute(filters: filters);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createNote({
    required String title,
    required String content,
    bool isPinned = false,
  }) async {
    try {
      final now = DateTime.now();
      final note = Note(
        id: null,
        title: title,
        content: content,
        createdAt: now,
        updatedAt: now,
        isPinned: isPinned,
      );

      await _createNote.execute(note);
      await loadNotes();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateNote(Note note) async {
    try {
      await _updateNote.execute(note.id!, note);
      await loadNotes();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> togglePin(Note note) async {
    final updated = Note(
      id: note.id,
      title: note.title,
      content: note.content,
      createdAt: note.createdAt,
      updatedAt: DateTime.now(),
      isPinned: !note.isPinned,
    );
    await updateNote(updated);
  }

  Future<void> deleteNote(int id) async {
    try {
      await _deleteNote.execute(id);
      await loadNotes();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
