import 'package:notesapp/features/notes/domain/entities/note.dart';

class NoteModel extends Note {
  NoteModel({
    super.id,
    required super.title,
    required super.content,
    required super.createdAt,
    required super.updatedAt,
    super.isPinned = false,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    final isPinnedRaw = json['isPinned'];
    final isPinnedValue = isPinnedRaw is int
        ? isPinnedRaw == 1
        : (isPinnedRaw as bool? ?? false);

    return NoteModel(
      id: json['id'] as int?,
      title: json['title'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      isPinned: isPinnedValue,
    );
  }

  Map<String, dynamic> toJson() {
    final json = {
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isPinned': isPinned ? 1 : 0,
    };
    if (id != null) {
      json['id'] = id!;
    }
    return json;
  }
}
