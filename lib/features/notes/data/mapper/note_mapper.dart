import 'package:notesapp/features/notes/data/model/note_model.dart';
import 'package:notesapp/features/notes/domain/entities/note.dart';

/// Mapper class to convert NoteModel to Note entity.
class NoteMapper {
  /// Converts a NoteModel to a Note entity.
  static Note toEntity(NoteModel model) => Note(
    id: model.id,
    title: model.title,
    content: model.content,
    createdAt: model.createdAt,
    updatedAt: model.updatedAt,
    isPinned: model.isPinned,
  );

  static NoteModel toModel(Note entity) => NoteModel(
    id: entity.id,
    title: entity.title,
    content: entity.content,
    createdAt: entity.createdAt,
    updatedAt: entity.updatedAt,
    isPinned: entity.isPinned,
  );
}
