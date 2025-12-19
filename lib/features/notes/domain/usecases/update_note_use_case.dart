import 'package:notesapp/features/notes/domain/entities/note.dart';
import 'package:notesapp/features/notes/domain/repository/note_repository.dart';

class UpdateNoteUseCase {
  final NoteRepository _noteRepository;

  UpdateNoteUseCase(this._noteRepository);

  Future<Note> execute(int id, Note note) =>
      _noteRepository.updateNote(id, note);
}
