import 'package:notesapp/core/database/app_database.dart';
import 'package:notesapp/features/notes/data/model/note_model.dart';

class NoteLocalDataSource extends AppDatabase<NoteModel> {
  @override
  String get boxName => 'notes';

  Future<NoteModel> createNote(NoteModel note) async => create(note);

  Future<NoteModel?> findNote(int id) async => find(id);

  Future<NoteModel> updateNote(NoteModel note) async => update(note);

  Future<List<NoteModel>> listNotes(Map<String, dynamic>? filters) async =>
      list(filters: filters);

  Future<void> deleteNote(int id) async => delete(id);
}
