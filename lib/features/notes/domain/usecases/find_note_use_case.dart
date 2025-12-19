import 'package:notesapp/features/notes/domain/entities/note.dart';
import 'package:notesapp/features/notes/domain/repository/note_repository.dart';

class FindNoteUseCase {
  final NoteRepository _noteRepository;

  FindNoteUseCase(this._noteRepository);

  Future<Note?> execute(int id) => _noteRepository.findNote(id);
}
