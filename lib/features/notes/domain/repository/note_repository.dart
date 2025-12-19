import 'package:notesapp/features/notes/domain/entities/note.dart';

/// Repository interface for managing notes.
abstract class NoteRepository {
  /// Creates a new note.
  Future<Note> createNote(Note note);

  /// Finds a note by its ID.
  Future<Note?> findNote(int id);

  /// Updates an existing note.
  Future<Note> updateNote(int id, Note note);

  /// Lists notes with optional filtering.
  Future<List<Note>> listNotes(Map<String, dynamic>? filters);

  /// Deletes a note by its ID.
  Future<void> deleteNote(int id);
}
