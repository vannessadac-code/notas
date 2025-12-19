import 'package:notesapp/features/notes/domain/entities/note.dart';
import 'package:notesapp/features/notes/domain/repository/note_repository.dart';

class CreateNoteUseCase {
  final NoteRepository _noteRepository;

  CreateNoteUseCase(this._noteRepository);

  Future<Note> execute(Note note) => _noteRepository.createNote(note);
}
