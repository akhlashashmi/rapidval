import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'local_storage_service.dart';

part 'hive_storage_service.g.dart';

class HiveStorageService implements LocalStorageService {
  static const String _settingsBox = 'settings';
  static const String _historyBox = 'history';
  static const String _dailyQuizBox = 'daily_quiz';

  @override
  Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_settingsBox);
    await Hive.openBox(_historyBox);
    await Hive.openBox(_dailyQuizBox);
  }

  @override
  Future<void> put(String boxName, String key, dynamic value) async {
    final box = Hive.box(boxName);
    await box.put(key, value);
  }

  @override
  dynamic get(String boxName, String key, {dynamic defaultValue}) {
    final box = Hive.box(boxName);
    return box.get(key, defaultValue: defaultValue);
  }

  @override
  Future<void> delete(String boxName, String key) async {
    final box = Hive.box(boxName);
    await box.delete(key);
  }

  @override
  Future<void> clear(String boxName) async {
    final box = Hive.box(boxName);
    await box.clear();
  }

  @override
  Future<void> saveQuizResult(Map<String, dynamic> result) async {
    final box = Hive.box(_historyBox);
    // Use a timestamp or uuid as key
    await box.add(result);
  }

  @override
  List<Map<String, dynamic>> getQuizHistory() {
    final box = Hive.box(_historyBox);
    return box.values
        .cast<Map<String, dynamic>>()
        .toList(); // Assuming simple maps for now
  }
}

@Riverpod(keepAlive: true)
LocalStorageService localStorageService(Ref ref) {
  return HiveStorageService();
}
