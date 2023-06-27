import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';

import '../../../services/hive_adapters/notes.dart';
import '../view/screens/add_notes.dart';

// required: associates our `main.dart` with the code generated by Freezed
part 'notes_model.freezed.dart';
// optional: Since our Person class is serializable, we must add this line.
// But if Person was not serializable, we could skip it.
part 'notes_model.g.dart';

@freezed
class NotesModel with _$NotesModel {
  const factory NotesModel(
      {String? audioPath,
      String? videoPath,
      List<String>? tagName,
      List<String>? references,
      List<NoteOption>? noteTypes,
      List<String>? selectedImages,
      String? textNote,
      String? noteTitle,
      DateTime? dateTime,
      String? key}) = _NotesModel;

  factory NotesModel.fromJson(Map<String, Object?> json) =>
      _$NotesModelFromJson(json);
}
