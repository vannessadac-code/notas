import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notesapp/app.dart';
import 'package:notesapp/core/database/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SQLite database
  try {
    await DatabaseHelper.instance.database;
  } catch (e) {
    debugPrint('Failed to initialize database: $e');
  }

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const App());
}
