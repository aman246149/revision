// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notes_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_NotesModel _$$_NotesModelFromJson(Map<String, dynamic> json) =>
    _$_NotesModel(
      audioPath: json['audioPath'] as String?,
      videoPath: json['videoPath'] as String?,
      tagName:
          (json['tagName'] as List<dynamic>?)?.map((e) => e as String).toList(),
      references: (json['references'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      noteTypes: (json['noteTypes'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$NoteOptionEnumMap, e))
          .toList(),
      selectedImages: (json['selectedImages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      textNote: json['textNote'] as String?,
      noteTitle: json['noteTitle'] as String?,
      dateTime: json['dateTime'] == null
          ? null
          : DateTime.parse(json['dateTime'] as String),
      key: json['key'] as String?,
    );

Map<String, dynamic> _$$_NotesModelToJson(_$_NotesModel instance) =>
    <String, dynamic>{
      'audioPath': instance.audioPath,
      'videoPath': instance.videoPath,
      'tagName': instance.tagName,
      'references': instance.references,
      'noteTypes':
          instance.noteTypes?.map((e) => _$NoteOptionEnumMap[e]!).toList(),
      'selectedImages': instance.selectedImages,
      'textNote': instance.textNote,
      'noteTitle': instance.noteTitle,
      'dateTime': instance.dateTime?.toIso8601String(),
      'key': instance.key,
    };

const _$NoteOptionEnumMap = {
  NoteOption.Audio: 'Audio',
  NoteOption.Video: 'Video',
  NoteOption.Images: 'Images',
  NoteOption.Text: 'Text',
};
