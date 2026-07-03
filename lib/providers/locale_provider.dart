import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

/// Seçili dili yönetir ve `settings_box` içinde kalıcı tutar.
/// `null` döndüğünde sistem dili (cihaz) kullanılır.
class LocaleProvider extends ChangeNotifier {
  static const _key = 'locale_code';

  Locale? _locale;
  Locale? get locale => _locale;

  Box? get _box =>
      Hive.isBoxOpen('settings_box') ? Hive.box('settings_box') : null;

  LocaleProvider() {
    final code = _box?.get(_key) as String?;
    // İlk çalıştırmada (kayıt yoksa) varsayılan dil Türkçe.
    _locale = Locale(code ?? 'tr');
  }

  void setLocale(Locale? locale) {
    _locale = locale;
    if (locale == null) {
      _box?.delete(_key);
    } else {
      _box?.put(_key, locale.languageCode);
    }
    notifyListeners();
  }

  /// TR ↔ EN arasında geçiş yapar.
  void toggle() {
    final next =
        (_locale?.languageCode == 'en') ? const Locale('tr') : const Locale('en');
    setLocale(next);
  }
}
