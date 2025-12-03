import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../services/local_storage/local_storage_service.dart';
import '../services/local_storage/hive_storage_service.dart';

class ThemeController extends StateNotifier<ThemeMode> {
  final LocalStorageService _storage;
  static const _themeKey = 'theme_mode';
  static const _settingsBox = 'settings';

  ThemeController(this._storage) : super(ThemeMode.system) {
    _loadTheme();
  }

  void _loadTheme() {
    final savedMode = _storage.get(_settingsBox, _themeKey) as String?;
    state = _parseMode(savedMode);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await _storage.put(_settingsBox, _themeKey, mode.name);
  }

  ThemeMode _parseMode(String? mode) {
    switch (mode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }
}

final themeControllerProvider =
    StateNotifierProvider<ThemeController, ThemeMode>((ref) {
      final storage = ref.watch(localStorageServiceProvider);
      return ThemeController(storage);
    });
