
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

import 'hive_adapters/notes.dart';

@lazySingleton
class DataBaseService {
  Box? box;

  Future<void> openBox() async {
    Hive.registerAdapter(NotesAdapter()); // Register the NotesAdapter
    box = await Hive.openBox('sound_box');
  }

  Future<void> putBox(Notes notes) async {
    // Update the method to accept Notes
    if (box == null) {
      throw Exception('Box is not opened');
    }
    await box!.put(notes.dateTime.toString(), notes);
  }

  Future<Notes?> getBox(String key) async {
    if (box == null) {
      throw Exception('Box is not opened');
    }
    var data = await box!.get(key) as Notes?;
    print(data);
    return await box!.get(key) as Notes?;
  }

  Future<List<Notes>> getAllRecordings() async {
    if (box == null) {
      return [];
    }
    var keys = box!.keys.toList();
    var notesList = <Notes>[];
    for (var key in keys) {
      var notes = box!.get(key) as Notes?;
      if (notes != null) {
        notes.key = key;
        notesList.add(notes);
      }
    }
    return notesList;
  }

  Future<void> deleteBox() async {
    if (box == null) {
      throw Exception('Box is not opened');
    }

    await box!.delete('sound');
  }
}
