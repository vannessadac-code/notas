import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:notesapp/features/notes/presentation/notifiers/notes_notifier.dart';
import 'package:notesapp/features/notes/presentation/widgets/delete_dialog.dart';
import 'package:notesapp/features/notes/presentation/widgets/note_form.dart';
import 'package:provider/provider.dart';
import 'package:notesapp/features/notes/presentation/screens/note_details_screen.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  @override
  void initState() {
    super.initState();
    // Load notes when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotesNotifier>().loadNotes();
    });
  }

  String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes < 1) {
          return 'Just now';
        }
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${dateTime.month}/${dateTime.day}/${dateTime.year}';
    }
  }

  void _showCreateNoteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Note'),
        content: NoteForm(
          submitLabel: 'Create',
          onSubmit: (title, content) {
            context.read<NotesNotifier>().createNote(
              title: title,
              content: content,
            );
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _showEditNoteDialog(dynamic note) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _openNoteDetails(dynamic note) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => NoteDetailsScreen(note: note)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        surfaceTintColor: Colors.transparent,
      ),
      body: Consumer<NotesNotifier>(
        builder: (context, notifier, _) {
          if (notifier.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (notifier.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${notifier.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => notifier.loadNotes(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (notifier.notes.isEmpty) {
            return const Center(
              child: Text('No notes yet. Tap + to create one!'),
            );
          }

          return LayoutGrid(
            columnSizes: [1.fr, 1.fr],
            rowSizes: List.generate(
              (notifier.notes.length + 1) ~/ 2,
              (_) => auto,
            ),
            children: notifier.notes.asMap().entries.map((entry) {
              final index = entry.key;
              final note = entry.value;

              return GridPlacement(
                columnStart: index % 2,
                rowStart: index ~/ 2,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: GestureDetector(
                      onTap: () => _openNoteDetails(note),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.white, Colors.grey.shade50],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Header with title and menu
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      note.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        letterSpacing: 0.3,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (note.isPinned)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Icon(
                                        Icons.push_pin,
                                        color: Colors.blue.shade600,
                                        size: 18,
                                      ),
                                    ),
                                  PopupMenuButton<String>(
                                    icon: Icon(
                                      Icons.more_vert,
                                      color: Colors.grey.shade600,
                                      size: 20,
                                    ),
                                    onSelected: (value) {
                                      if (value == 'edit') {
                                        _showEditNoteDialog(note);
                                      } else if (value == 'pin') {
                                        notifier.togglePin(note);
                                      } else if (value == 'delete') {
                                        handleDelete(
                                          context,
                                          () => notifier.deleteNote(note.id!),
                                        );
                                      }
                                    },
                                    itemBuilder: (BuildContext context) =>
                                        <PopupMenuEntry<String>>[
                                          PopupMenuItem<String>(
                                            value: 'edit',
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.edit_outlined,
                                                  size: 18,
                                                  color: Colors.orange.shade600,
                                                ),
                                                const SizedBox(width: 12),
                                                const Text('Edit'),
                                              ],
                                            ),
                                          ),
                                          const PopupMenuDivider(),
                                          PopupMenuItem<String>(
                                            value: 'pin',
                                            child: Row(
                                              children: [
                                                Icon(
                                                  note.isPinned
                                                      ? Icons.push_pin
                                                      : Icons.push_pin_outlined,
                                                  size: 18,
                                                  color: Colors.blue.shade600,
                                                ),
                                                const SizedBox(width: 12),
                                                Text(
                                                  note.isPinned
                                                      ? 'Unpin'
                                                      : 'Pin',
                                                ),
                                              ],
                                            ),
                                          ),
                                          const PopupMenuDivider(),
                                          PopupMenuItem<String>(
                                            value: 'delete',
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.delete_outline,
                                                  size: 18,
                                                  color: Colors.red.shade600,
                                                ),
                                                const SizedBox(width: 12),
                                                const Text('Delete'),
                                              ],
                                            ),
                                          ),
                                        ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              // Content
                              Text(
                                note.content,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade800,
                                  height: 1.4,
                                ),
                                maxLines: 5,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 12),
                              // Timestamp
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  _formatDate(note.updatedAt),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateNoteDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
