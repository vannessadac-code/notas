import 'package:notesapp/features/notes/domain/entities/note.dart';
import 'package:notesapp/features/notes/domain/repository/note_repository.dart';

class ListNotesUseCase {
  final NoteRepository _noteRepository;

  ListNotesUseCase(this._noteRepository);

  Future<List<Note>> execute({Map<String, dynamic>? filters}) =>
      _noteRepository.listNotes(filters);
}
