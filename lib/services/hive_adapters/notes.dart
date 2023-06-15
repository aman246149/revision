import 'package:hive_flutter/adapters.dart';

part 'notes.g.dart';

@HiveType(typeId: 1)
class Notes {
  @HiveField(0)
  String? filePath;

  @HiveField(1)
  String? fileName;

  @HiveField(2)
  String? topicName;

  @HiveField(3)
  DateTime? dateTime;

  String? key;
  bool isCurrentlyPlaying = false;
}
