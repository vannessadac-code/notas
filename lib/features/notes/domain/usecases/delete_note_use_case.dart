import 'package:notesapp/features/notes/domain/repository/note_repository.dart';

class DeleteNoteUseCase {
  final NoteRepository _noteRepository;

  DeleteNoteUseCase(this._noteRepository);

  Future<void> execute(int id) => _noteRepository.deleteNote(id);
}
