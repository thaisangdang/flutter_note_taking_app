import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/notes_page.dart';

void main() async {
  // 1. Initialize Hive
  await Hive.initFlutter();

  // 2. Open a "Box" (Think of it like a table or a file)
  await Hive.openBox('note_database');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.yellow),
      home: const NotesPage(),
    );
  }
}
