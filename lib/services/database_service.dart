import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class DataBaseService<T> {
  Box<T>? box;

  Future<void> openBox(String boxName) async {
    box = await Hive.openBox<T>(boxName);
  }

  Future<void> putBox(String key, T data) async {
    if (box == null) {
      throw Exception('Box is not opened');
    }
    await box!.put(key, data);
  }

  Future<T?> getBox(String key) async {
    if (box == null) {
      throw Exception('Box is not opened');
    }
    return await box!.get(key);
  }

  Future<List<T>> getAllData() async {
    if (box == null) {
      return [];
    }
    return box!.values.toList();
  }

  Future<List<dynamic>> getAllDataKeys()  async{
  if (box == null) {
    return [];
  }
  return box!.keys.toList();
}

  Future<void> deleteBox() async {
    if (box == null) {
      throw Exception('Box is not opened');
    }
    await box!.clear();
  }
}