// WelcomeScreen için temel smoke test.
//
// MyApp doğrudan pump edilemez çünkü Provider ve açık Hive kutuları gerektirir.
// Bunun yerine, dış bağımlılığı olmayan WelcomeScreen'in sorunsuz çizildiğini
// ve temel giriş seçeneklerini gösterdiğini doğruluyoruz.

import 'package:coffee_shop_loyalty/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:coffee_shop_loyalty/screens/welcome_screen.dart';

void main() {
  testWidgets('WelcomeScreen giriş seçeneklerini gösterir',
      (WidgetTester tester) async {
    // Gerçekçi, dar bir telefon yüzeyi (iPhone 12/13 mantıksal boyutu).
    // Cam butonlar bu genişlikte de taşmamalı (yatay sağlamlaştırma kontrolü).
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    // Lokalizasyon delegeleri + Türkçe locale ile pump et.
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('tr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const WelcomeScreen(),
    ));
    // Giriş animasyonunun tamamlanması için kareleri ilerlet.
    await tester.pump(const Duration(seconds: 1));

    // Misafir girişi artık welcome'da değil, üye seçim ekranında.
    // Welcome yalnızca üye girişine yönlendirir.
    expect(find.text('Giriş Yap'), findsOneWidget);
    expect(find.textContaining('Hoş Geldiniz'), findsOneWidget);
  });
}
