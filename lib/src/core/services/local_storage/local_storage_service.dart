abstract class LocalStorageService {
  Future<void> init();
  Future<void> put(String boxName, String key, dynamic value);
  dynamic get(String boxName, String key, {dynamic defaultValue});
  Future<void> delete(String boxName, String key);
  Future<void> clear(String boxName);

  // Specific methods for features can be added or kept generic
  Future<void> saveQuizResult(Map<String, dynamic> result);
  List<Map<String, dynamic>> getQuizHistory();
}
