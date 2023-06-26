// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notes.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotesHiveAdapter extends TypeAdapter<NotesHive> {
  @override
  final int typeId = 1;

  @override
  NotesHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotesHive()
      ..audioPath = fields[0] as String?
      ..videoPath = fields[1] as String?
      ..tagName = (fields[2] as List?)?.cast<String>()
      ..references = (fields[3] as List?)?.cast<String>()
      ..noteTypes = (fields[4] as List?)?.cast<NoteOption>()
      ..selectedImages = (fields[5] as List?)?.cast<String>()
      ..textNote = fields[6] as String?
      ..noteTitle = fields[7] as String?
      ..dateTime = fields[8] as DateTime?;
  }

  @override
  void write(BinaryWriter writer, NotesHive obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.audioPath)
      ..writeByte(1)
      ..write(obj.videoPath)
      ..writeByte(2)
      ..write(obj.tagName)
      ..writeByte(3)
      ..write(obj.references)
      ..writeByte(4)
      ..write(obj.noteTypes)
      ..writeByte(5)
      ..write(obj.selectedImages)
      ..writeByte(6)
      ..write(obj.textNote)
      ..writeByte(7)
      ..write(obj.noteTitle)
      ..writeByte(8)
      ..write(obj.dateTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotesHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
