import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

/// Uygulama tema modunu (sistem/açık/koyu) yönetir ve `settings_box`
/// içinde kalıcı tutar. Varsayılan: sistem.
class ThemeProvider extends ChangeNotifier {
  static const _key = 'theme_mode';

  ThemeMode _mode = ThemeMode.system;
  ThemeMode get mode => _mode;

  Box? get _box =>
      Hive.isBoxOpen('settings_box') ? Hive.box('settings_box') : null;

  ThemeProvider() {
    switch (_box?.get(_key) as String?) {
      case 'light':
        _mode = ThemeMode.light;
        break;
      case 'dark':
        _mode = ThemeMode.dark;
        break;
      default:
        _mode = ThemeMode.system;
    }
  }

  void setMode(ThemeMode mode) {
    _mode = mode;
    _box?.put(_key, mode.name); // 'system' | 'light' | 'dark'
    notifyListeners();
  }
}
