import 'dart:async';

import 'package:coffee_shop_loyalty/l10n/app_localizations.dart';
import 'package:coffee_shop_loyalty/providers/locale_provider.dart';
import 'package:coffee_shop_loyalty/providers/theme_provider.dart';
import 'package:coffee_shop_loyalty/screens/welcome_screen.dart';
import 'package:coffee_shop_loyalty/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:coffee_shop_loyalty/models/coffee_model.dart';
import 'package:coffee_shop_loyalty/models/user_model.dart';
import 'package:coffee_shop_loyalty/models/order_model.dart';
import 'package:coffee_shop_loyalty/providers/cart_provider.dart';
import 'package:coffee_shop_loyalty/providers/product_provider.dart';
import 'package:coffee_shop_loyalty/providers/user_provider.dart';
import 'package:coffee_shop_loyalty/providers/order_provider.dart';
import 'package:coffee_shop_loyalty/utils/ads_service.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Hive.initFlutter();

    Hive.registerAdapter(CoffeeAdapter());
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(OrderItemAdapter());
    Hive.registerAdapter(OrderAdapter());

    await Hive.openBox<User>('user_box');
    await Hive.openBox<Coffee>('coffee_box');
    await Hive.openBox<Coffee>('cart_box');
    await Hive.openBox<Order>('order_box');
    // Admin PIN gibi uygulama ayarları için genel amaçlı kutu
    await Hive.openBox('settings_box');

    // AdMob'u başlat — açılışı bloklamaması için beklenmiyor, hatalar
    // servisin kendi içinde yutuluyor.
    unawaited(AdsService.initialize());

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ProductProvider()),
          ChangeNotifierProvider(create: (_) => CartProvider()),
          ChangeNotifierProvider(create: (_) => UserProvider()),
          ChangeNotifierProvider(create: (_) => OrderProvider()),
          ChangeNotifierProvider(create: (_) => LocaleProvider()),
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ],
        child: const MyApp(),
      ),
    );
  } catch (e) {
    debugPrint("KRİTİK BAŞLATMA HATASI: $e");
    runApp(
      MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.brown.shade900,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.coffee, size: 64, color: Colors.white54),
                const SizedBox(height: 16),
                const Text("Uygulama başlatılamadı",
                    style: TextStyle(color: Colors.white, fontSize: 18)),
                const SizedBox(height: 8),
                Text(e.toString(),
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                    textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>().locale;
    final themeMode = context.watch<ThemeProvider>().mode;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => AppLocalizations.of(context).appName,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const WelcomeScreen(),
    );
  }
}
