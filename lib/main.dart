import 'package:flutter/material.dart';
import 'package:note_demo_nodejs/pages/notes.dart';
import 'package:note_demo_nodejs/pages/note_desc.dart';
import 'package:note_demo_nodejs/providers/note_provider.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (context)=>NotesProvider(),
          ),
        ],
      child: MaterialApp(
        title: "UserNotes",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.blue
        ),
        home: const NotesList(),
        // home: const NoteDetail(),
      ),
    );

    return MaterialApp(
      title: "UserNotes",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue
      ),
      home: const NotesList(),
      // home: const NoteDetail(),
    );
  }
}