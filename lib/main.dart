import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'home_page.dart';
import 'note_database.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // flutter runtime
  await initDatabase();
  runApp(const MyApp());
}
Future<void> initDatabase() async {
  await copyDatabase();

  //get database object
  //connect to database
  final dir = await getApplicationDocumentsDirectory();
  final dbPath = join(dir.path, 'notes.db');
// expensive_> so make it global
  database = await $FloorNoteDatabase.databaseBuilder(dbPath).build();
}
late final NoteDatabase database;

Future<void> copyDatabase() async {
  final dir = await getApplicationDocumentsDirectory();
  final path = join(dir.path, 'notes.db'); // c://app1/movies.db.db
  print(dir);

  if (File(path).existsSync()) return;

  //copy from assets to this path
  ByteData data = await rootBundle.load('assets/databases/note.db');
  List<int> bytes =
  data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  await File(path).writeAsBytes(bytes);
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(home:HomePage());
  }
}