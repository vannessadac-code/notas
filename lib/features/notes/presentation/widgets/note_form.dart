import 'package:flutter/material.dart';
import 'package:notesapp/shared/widgets/text_field_widget.dart';

class NoteForm extends StatefulWidget {
  final String initialTitle;
  final String initialContent;
  final String submitLabel;
  final void Function(String title, String content) onSubmit;
  final VoidCallback? onCancel;

  const NoteForm({
    super.key,
    this.initialTitle = '',
    this.initialContent = '',
    required this.submitLabel,
    required this.onSubmit,
    this.onCancel,
  });

  @override
  State<NoteForm> createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _contentController = TextEditingController(text: widget.initialContent);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteractionIfError,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFieldWidget(
            controller: _titleController,
            hintText: 'Title',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "El título es requerido";
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFieldWidget(
            controller: _contentController,
            hintText: 'Content',
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: widget.onCancel ?? () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    widget.onSubmit(
                      _titleController.text.trim(),
                      _contentController.text.trim(),
                    );
                  }
                },
                child: Text(widget.submitLabel),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
