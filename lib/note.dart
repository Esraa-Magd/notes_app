import 'package:floor/floor.dart';

@Entity(tableName: 'notes')
class Note{
  @PrimaryKey(autoGenerate: true)
 final int? id;
final String  text;
final String? location;

  Note({this.id, required this.text, this.location});
}