import "package:flutter/material.dart";
import "package:notesapp/features/notes/domain/entities/note.dart";
import "package:notesapp/features/notes/presentation/notifiers/notes_notifier.dart";
import "package:notesapp/features/notes/presentation/widgets/note_form.dart";
import "package:provider/provider.dart";

class NoteDetailsScreen extends StatelessWidget {
  final Note note;
  const NoteDetailsScreen({super.key, required this.note});

  String _formatFullDate(DateTime dt) {
    String two(int n) => n.toString().padLeft(2, '0');
    return "${dt.month}/${dt.day}/${dt.year} ${two(dt.hour)}:${two(dt.minute)}";
  }

  void _showEditNoteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit Note'),
        content: NoteForm(
          initialTitle: note.title,
          initialContent: note.content,
          submitLabel: 'Save',
          onSubmit: (title, content) {
            final updatedNote = note.copyWith(
              title: title,
              content: content,
              updatedAt: DateTime.now(),
            );
            context.read<NotesNotifier>().updateNote(updatedNote);
            Navigator.pop(dialogContext);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Note'),
        content: const Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<NotesNotifier>().deleteNote(note.id!);
              Navigator.pop(dialogContext);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note Details'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showEditNoteDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteConfirmation(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      note.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (note.isPinned)
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Icon(Icons.push_pin, color: Colors.blue),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Updated: ${_formatFullDate(note.updatedAt)}',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              Text(
                'Created: ${_formatFullDate(note.createdAt)}',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              const Divider(height: 24),
              SelectableText(
                note.content,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
