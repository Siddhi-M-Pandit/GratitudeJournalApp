import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'journal_entry.dart';
import 'journal_lists.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }  

  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key}) ; 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gratitude Journal',
      theme: ThemeData(primarySwatch: Colors.brown),
      home: JournalListScreen(),
      routes: {'/new-entry': (context) => JournalEntryScreen()},
    );
  }

}