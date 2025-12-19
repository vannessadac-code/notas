import 'package:flutter/material.dart';
import 'package:notesapp/features/notes/data/datasources/note_local_datasource.dart';
import 'package:notesapp/features/notes/data/repository/note_repository_impl.dart';
import 'package:notesapp/features/notes/domain/repository/note_repository.dart';
import 'package:notesapp/features/notes/domain/usecases/create_note_use_case.dart';
import 'package:notesapp/features/notes/domain/usecases/update_note_use_case.dart';
import 'package:notesapp/features/notes/domain/usecases/delete_note_use_case.dart';
import 'package:notesapp/features/notes/domain/usecases/list_notes_use_case.dart';
import 'package:notesapp/features/notes/domain/usecases/find_note_use_case.dart';
import 'package:notesapp/features/notes/presentation/notifiers/notes_notifier.dart';
import 'package:notesapp/features/notes/presentation/screens/notes_screen.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Data sources
        Provider<NoteLocalDataSource>(create: (_) => NoteLocalDataSource()),

        // Repositories
        ProxyProvider<NoteLocalDataSource, NoteRepository>(
          update: (_, datasource, _) =>
              NoteRepositoryImpl(noteLocalDataSource: datasource),
        ),

        // Use cases
        ProxyProvider<NoteRepository, CreateNoteUseCase>(
          update: (_, repository, _) => CreateNoteUseCase(repository),
        ),
        ProxyProvider<NoteRepository, UpdateNoteUseCase>(
          update: (_, repository, __) => UpdateNoteUseCase(repository),
        ),
        ProxyProvider<NoteRepository, DeleteNoteUseCase>(
          update: (_, repository, __) => DeleteNoteUseCase(repository),
        ),
        ProxyProvider<NoteRepository, ListNotesUseCase>(
          update: (_, repository, __) => ListNotesUseCase(repository),
        ),
        ProxyProvider<NoteRepository, FindNoteUseCase>(
          update: (_, repository, __) => FindNoteUseCase(repository),
        ),

        // Notifiers/ViewModels
        ChangeNotifierProxyProvider4<
          CreateNoteUseCase,
          UpdateNoteUseCase,
          DeleteNoteUseCase,
          ListNotesUseCase,
          NotesNotifier
        >(
          create: (context) => NotesNotifier(
            createNoteUseCase: context.read<CreateNoteUseCase>(),
            updateNoteUseCase: context.read<UpdateNoteUseCase>(),
            deleteNoteUseCase: context.read<DeleteNoteUseCase>(),
            listNotesUseCase: context.read<ListNotesUseCase>(),
          ),
          update:
              (_, createNote, updateNote, deleteNote, listNotes, notifier) =>
                  notifier ??
                  NotesNotifier(
                    createNoteUseCase: createNote,
                    updateNoteUseCase: updateNote,
                    deleteNoteUseCase: deleteNote,
                    listNotesUseCase: listNotes,
                  ),
        ),
      ],
      child: MaterialApp(
        title: "Tasks App",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
        home: const NotesScreen(),
      ),
    );
  }
}
