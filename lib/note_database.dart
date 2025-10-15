import 'package:floor/floor.dart';
import 'package:notes_app/note_dao.dart';
// required package imports
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'note.dart';
part 'note_database.g.dart';
@Database(version: 1, entities: [Note])
abstract class NoteDatabase extends FloorDatabase{
  NoteDao get noteDao; //singleleton(function'getter')[cache]
}