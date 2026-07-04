import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:hive/hive.dart';

/// Admin PIN saklama ve kurtarma kodu doğrulama yardımcıları.
///
/// PIN, Hive'da SHA-256 hash olarak tutulur; düz metin saklanmaz.
/// Eski sürümlerin düz metin kaydı ilk erişimde hash'e taşınır.
class AdminSecurity {
  AdminSecurity._();

  static const _legacyPinKey = 'admin_pin';
  static const _pinHashKey = 'admin_pin_hash';

  /// PIN unutulduğunda sıfırlamayı yetkilendiren kurtarma kodu.
  /// Yayın build'i şu şekilde alınmalı:
  ///   flutter build appbundle --dart-define=ADMIN_RECOVERY_CODE=GIZLI-DEGER
  /// Tanım geçilmezse geliştirme varsayılanı kullanılır.
  static const recoveryCode = String.fromEnvironment(
    'ADMIN_RECOVERY_CODE',
    defaultValue: 'COFFEE-RESET-2024',
  );

  static Box get _settings => Hive.box('settings_box');

  static String hash(String pin) =>
      sha256.convert(utf8.encode(pin)).toString();

  /// Eski düz metin PIN kaydını hash'e taşır (bir kez çalışır).
  static void _migrateLegacyPin() {
    final legacy = _settings.get(_legacyPinKey);
    if (legacy is String && legacy.isNotEmpty) {
      _settings.put(_pinHashKey, hash(legacy));
    }
    if (legacy != null) _settings.delete(_legacyPinKey);
  }

  static bool get hasPin {
    _migrateLegacyPin();
    return _settings.get(_pinHashKey) != null;
  }

  static void setPin(String pin) => _settings.put(_pinHashKey, hash(pin));

  static bool verifyPin(String pin) {
    _migrateLegacyPin();
    return _settings.get(_pinHashKey) == hash(pin);
  }

  static Future<void> clearPin() async {
    await _settings.delete(_pinHashKey);
    await _settings.delete(_legacyPinKey);
  }
}
