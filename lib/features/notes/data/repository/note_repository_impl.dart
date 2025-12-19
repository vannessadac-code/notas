import 'package:notesapp/features/notes/data/datasources/note_local_datasource.dart';
import 'package:notesapp/features/notes/data/mapper/note_mapper.dart';
import 'package:notesapp/features/notes/domain/entities/note.dart';
import 'package:notesapp/features/notes/domain/repository/note_repository.dart';

class NoteRepositoryImpl implements NoteRepository {
  final NoteLocalDataSource _noteLocalDataSource;

  NoteRepositoryImpl({required NoteLocalDataSource noteLocalDataSource})
    : _noteLocalDataSource = noteLocalDataSource;

  @override
  Future<Note> createNote(Note note) async =>
      await _noteLocalDataSource.createNote(NoteMapper.toModel(note));

  @override
  Future<void> deleteNote(int id) => _noteLocalDataSource.deleteNote(id);

  @override
  Future<Note?> findNote(int id) => _noteLocalDataSource
      .findNote(id)
      .then((model) => model != null ? NoteMapper.toEntity(model) : null);

  @override
  Future<List<Note>> listNotes(Map<String, dynamic>? filters) =>
      _noteLocalDataSource
          .listNotes(filters)
          .then(
            (models) =>
                models.map((model) => NoteMapper.toEntity(model)).toList(),
          );

  @override
  Future<Note> updateNote(int id, Note note) => _noteLocalDataSource
      .updateNote(NoteMapper.toModel(note))
      .then((model) => NoteMapper.toEntity(model));
}
