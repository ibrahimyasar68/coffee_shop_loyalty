import 'package:coffee_shop_loyalty/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:coffee_shop_loyalty/models/coffee_model.dart';
import 'package:coffee_shop_loyalty/models/user_model.dart';
import 'package:coffee_shop_loyalty/providers/cart_provider.dart';
import 'package:coffee_shop_loyalty/providers/product_provider.dart';
import 'package:coffee_shop_loyalty/providers/user_provider.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Hive.initFlutter();

    Hive.registerAdapter(CoffeeAdapter());
    Hive.registerAdapter(UserAdapter());

    // Kutuları açarken isimlerin Provider'larla %100 uyuştuğundan emin olduk
    await Hive.openBox<User>('user_box');
    await Hive.openBox<Coffee>('coffee_box');
    await Hive.openBox<Coffee>('cart_box');

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ProductProvider()),
          ChangeNotifierProvider(create: (_) => CartProvider()),
          ChangeNotifierProvider(create: (_) => UserProvider()),
        ],
        child: const MyApp(),
      ),
    );
  } catch (e) {
    debugPrint("KRİTİK BAŞLATMA HATASI: $e");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Coffee Shop & Loyalty',
      theme: ThemeData(primarySwatch: Colors.brown, useMaterial3: true),
      home: const WelcomeScreen(),
    );
  }
}
