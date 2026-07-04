import 'dart:io';

import 'package:coffee_shop_loyalty/utils/security.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

/// AdminSecurity testleri: PIN hash'leme, doğrulama ve eski düz metin
/// kayıttan hash'e geçiş (migration).
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;

  setUpAll(() {
    tempDir = Directory.systemTemp.createTempSync('coffee_security_test');
    Hive.init(tempDir.path);
  });

  setUp(() async {
    await Hive.openBox('settings_box');
  });

  tearDown(() async {
    await Hive.deleteBoxFromDisk('settings_box');
  });

  tearDownAll(() {
    if (tempDir.existsSync()) tempDir.deleteSync(recursive: true);
  });

  group('AdminSecurity', () {
    test('PIN hash olarak saklanır, düz metin bulunmaz', () {
      AdminSecurity.setPin('1234');

      final box = Hive.box('settings_box');
      expect(box.get('admin_pin'), isNull);
      expect(box.get('admin_pin_hash'), isNotNull);
      expect(box.get('admin_pin_hash'), isNot('1234'));
      expect(AdminSecurity.hasPin, isTrue);
    });

    test('doğru PIN doğrulanır, yanlış PIN reddedilir', () {
      AdminSecurity.setPin('1234');

      expect(AdminSecurity.verifyPin('1234'), isTrue);
      expect(AdminSecurity.verifyPin('0000'), isFalse);
      expect(AdminSecurity.verifyPin(''), isFalse);
    });

    test('eski düz metin PIN hash\'e taşınır ve çalışmaya devam eder', () {
      final box = Hive.box('settings_box');
      // Eski sürümün bıraktığı düz metin kayıt
      box.put('admin_pin', '5678');

      expect(AdminSecurity.hasPin, isTrue); // migration burada tetiklenir
      expect(box.get('admin_pin'), isNull); // düz metin silindi
      expect(box.get('admin_pin_hash'), isNotNull);
      expect(AdminSecurity.verifyPin('5678'), isTrue);
      expect(AdminSecurity.verifyPin('1234'), isFalse);
    });

    test('clearPin PIN\'i siler ve kurulum moduna döner', () async {
      AdminSecurity.setPin('1234');
      await AdminSecurity.clearPin();

      expect(AdminSecurity.hasPin, isFalse);
      expect(AdminSecurity.verifyPin('1234'), isFalse);
    });

    test('kurtarma kodu dart-define yoksa geliştirme varsayılanını taşır',
        () {
      // Test ortamında --dart-define geçilmediğinden varsayılan beklenir.
      expect(AdminSecurity.recoveryCode, 'COFFEE-RESET-2024');
    });
  });
}
