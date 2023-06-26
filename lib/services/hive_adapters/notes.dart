import 'package:hive_flutter/adapters.dart';

import '../../features/DSA NOTES/view/screens/add_notes.dart';

part 'notes.g.dart';

@HiveType(typeId: 1)
class NotesHive {
  @HiveField(0)
  String? audioPath;

  @HiveField(1)
  String? videoPath;

  @HiveField(2)
  List<String>? tagName;

  @HiveField(3)
  List<String>? references;

  @HiveField(4)
  List<NoteOption>? noteTypes;

  @HiveField(5)
  List<String>? selectedImages;

  @HiveField(6)
  String? textNote;

  @HiveField(7)
  String? noteTitle;

  @HiveField(8)
  DateTime? dateTime;

  String? key;
}
