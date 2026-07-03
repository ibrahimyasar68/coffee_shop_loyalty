import 'dart:io';

import 'package:coffee_shop_loyalty/models/coffee_model.dart';
import 'package:coffee_shop_loyalty/models/order_model.dart';
import 'package:coffee_shop_loyalty/models/user_model.dart';
import 'package:coffee_shop_loyalty/providers/cart_provider.dart';
import 'package:coffee_shop_loyalty/providers/order_provider.dart';
import 'package:coffee_shop_loyalty/providers/user_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

/// Provider'ların iş mantığı testleri.
///
/// Provider'lar Hive kutularına bağımlı olduğundan, her test için geçici
/// bir dizinde Hive başlatılır, adapter'lar bir kez kaydedilir ve kutular
/// her testte taze açılıp sonunda temizlenir.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;

  Coffee sampleCoffee({
    int id = 1,
    String name = 'Latte',
    double price = 100,
    int points = 10,
  }) =>
      Coffee(
        id: id,
        category: 'sıcak',
        name: name,
        price: price,
        imagePath: '',
        points: points,
        note: '',
      );

  setUpAll(() async {
    tempDir = Directory.systemTemp.createTempSync('coffee_test');
    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(UserAdapter());
    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(CoffeeAdapter());
    if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(OrderItemAdapter());
    if (!Hive.isAdapterRegistered(3)) Hive.registerAdapter(OrderAdapter());
  });

  setUp(() async {
    await Hive.openBox<Coffee>('cart_box');
    await Hive.openBox<Coffee>('coffee_box');
    await Hive.openBox<User>('user_box');
    await Hive.openBox<Order>('order_box');
  });

  tearDown(() async {
    await Hive.deleteBoxFromDisk('cart_box');
    await Hive.deleteBoxFromDisk('coffee_box');
    await Hive.deleteBoxFromDisk('user_box');
    await Hive.deleteBoxFromDisk('order_box');
  });

  tearDownAll(() {
    if (tempDir.existsSync()) tempDir.deleteSync(recursive: true);
  });

  group('CartProvider', () {
    test('boyut çarpanı fiyat ve puanı doğru hesaplar', () {
      final cart = CartProvider();
      final coffee = sampleCoffee(price: 100, points: 10);

      cart.addToCartWithSize(coffee, 'Küçük'); // -%10
      cart.addToCartWithSize(coffee, 'Orta'); //  baz
      cart.addToCartWithSize(coffee, 'Büyük'); // +%10

      final items = cart.cart;
      expect(items.length, 3);

      final kucuk = items.firstWhere((c) => c.size == 'Küçük');
      final orta = items.firstWhere((c) => c.size == 'Orta');
      final buyuk = items.firstWhere((c) => c.size == 'Büyük');

      expect(kucuk.price, 90);
      expect(orta.price, 100);
      expect(buyuk.price, 110);

      expect(kucuk.points, 9);
      expect(orta.points, 10);
      expect(buyuk.points, 11);
    });

    test('ürün adı boyutla kirletilmez, isim temiz kalır', () {
      final cart = CartProvider();
      cart.addToCartWithSize(sampleCoffee(name: 'Latte'), 'Büyük');

      expect(cart.cart.single.name, 'Latte');
      expect(cart.cart.single.size, 'Büyük');
    });

    test('toplam tutar ve kazanılan puan toplanır', () {
      final cart = CartProvider();
      cart.addToCartWithSize(sampleCoffee(price: 100, points: 10), 'Orta');
      cart.addToCartWithSize(sampleCoffee(price: 100, points: 10), 'Büyük');

      expect(cart.totalCartPrice, 210); // 100 + 110
      expect(cart.earnedPoints, 21); // 10 + 11
    });

    test('groupedCart aynı ürün+boyutu adetiyle gruplar', () async {
      final cart = CartProvider();
      cart.addToCartWithSize(sampleCoffee(name: 'Latte'), 'Orta');
      cart.addToCartWithSize(sampleCoffee(name: 'Latte'), 'Orta');
      cart.addToCartWithSize(sampleCoffee(name: 'Latte'), 'Büyük');

      final lines = cart.groupedCart;
      expect(lines.length, 2); // Latte(Orta) + Latte(Büyük)
      final orta = lines.firstWhere((l) => l.sample.size == 'Orta');
      expect(orta.quantity, 2);
      expect(orta.lineTotal, orta.sample.price * 2);
    });

    test('incrementLine / decrementLine adet değiştirir', () async {
      final cart = CartProvider();
      cart.addToCartWithSize(sampleCoffee(name: 'Latte'), 'Orta');

      cart.incrementLine(cart.groupedCart.first);
      expect(cart.groupedCart.first.quantity, 2);

      await cart.decrementLine(cart.groupedCart.first);
      expect(cart.groupedCart.first.quantity, 1);

      await cart.decrementLine(cart.groupedCart.first);
      expect(cart.groupedCart, isEmpty);
    });

    test('clearCart sepeti boşaltır', () async {
      final cart = CartProvider();
      cart.addToCartWithSize(sampleCoffee(), 'Orta');
      expect(cart.cart, isNotEmpty);

      await cart.clearCart();
      expect(cart.cart, isEmpty);
    });

    test('removeFromCart yalnızca seçilen öğeyi siler', () async {
      final cart = CartProvider();
      cart.addToCartWithSize(sampleCoffee(name: 'Latte'), 'Orta');
      cart.addToCartWithSize(sampleCoffee(name: 'Espresso'), 'Orta');

      await cart.removeFromCart(cart.cart.firstWhere((c) => c.name == 'Latte'));

      expect(cart.cart.length, 1);
      expect(cart.cart.single.name, 'Espresso');
    });
  });

  group('OrderProvider', () {
    test('aynı ürün+boyut tek satırda gruplanır, quantity artar', () async {
      final orders = OrderProvider();
      await orders.saveOrder(
        cartItems: [
          sampleCoffee(name: 'Latte')..size = 'Orta',
          sampleCoffee(name: 'Latte')..size = 'Orta',
        ],
        userName: 'Ali Veli',
      );

      final items = orders.allOrders.single.items;
      expect(items.length, 1);
      expect(items.single.quantity, 2);
    });

    test('farklı boyutlar ayrı satırlara ayrılır', () async {
      final orders = OrderProvider();
      await orders.saveOrder(
        cartItems: [
          sampleCoffee(name: 'Latte')..size = 'Küçük',
          sampleCoffee(name: 'Latte')..size = 'Büyük',
        ],
        userName: 'Ali Veli',
      );

      final items = orders.allOrders.single.items;
      expect(items.length, 2);
      expect(items.map((i) => i.size).toSet(), {'Küçük', 'Büyük'});
    });

    test('sipariş toplam fiyat ve puanı sepetten toplanır', () async {
      final orders = OrderProvider();
      await orders.saveOrder(
        cartItems: [
          sampleCoffee(price: 90, points: 9),
          sampleCoffee(price: 110, points: 11),
        ],
        userName: 'Ali Veli',
      );

      final order = orders.allOrders.single;
      expect(order.totalPrice, 200);
      expect(order.totalPoints, 20);
    });

    test('boş sepet sipariş oluşturmaz', () async {
      final orders = OrderProvider();
      await orders.saveOrder(cartItems: [], userName: 'Ali Veli');
      expect(orders.allOrders, isEmpty);
    });

    test('ordersForUser yalnızca o kullanıcının siparişlerini döner', () async {
      final orders = OrderProvider();
      await orders.saveOrder(cartItems: [sampleCoffee()], userName: 'Ali Veli');
      await orders.saveOrder(cartItems: [sampleCoffee()], userName: 'Ayşe Yıldız');

      expect(orders.ordersForUser('Ali Veli').length, 1);
      expect(orders.ordersForUser('Ayşe Yıldız').length, 1);
      expect(orders.ordersForUser('Yok Kimse'), isEmpty);
    });
  });

  group('UserProvider', () {
    User newUser({String phone = '5550001', int points = 0}) => User(
          id: 1,
          name: 'Ali',
          surname: 'Veli',
          phone: phone,
          image: '',
          points: points,
          note: '',
        );

    test('addUser aynı telefonla ikinci kaydı reddeder', () async {
      final users = UserProvider();
      expect(await users.addUser(newUser(phone: '5550001')), isTrue);
      expect(await users.addUser(newUser(phone: '5550001')), isFalse);
    });

    test('registeredUsers misafiri hariç tutar; loginWithUser giriş yapar',
        () async {
      final users = UserProvider();
      await users.addUser(newUser(phone: '5550001'));

      final members = users.registeredUsers;
      expect(members.any((u) => u.phone == '5550001'), isTrue);
      expect(members.any((u) => u.key == 'misafir'), isFalse);

      users.loginWithUser(members.firstWhere((u) => u.phone == '5550001'));
      expect(users.currentUser!.phone, '5550001');
    });

    test('addPoints giriş yapan üyeye puan ekler ve kalıcı yapar', () async {
      final users = UserProvider();
      await users.addUser(newUser(phone: '5550001', points: 0));
      users.loginWithUser(
          users.registeredUsers.firstWhere((u) => u.phone == '5550001'));

      users.addPoints(15);

      expect(users.currentUser!.points, 15);
      // Kalıcılık: kutudan yeniden okunduğunda da 15 olmalı
      expect(Hive.box<User>('user_box').get('5550001')!.points, 15);
    });

    test('addPoints misafir (girişsiz) için puan biriktirmez', () async {
      final users = UserProvider();
      users.loginAsGuest();
      users.addPoints(15); // sessizce yok sayılmalı

      // Misafir hesabı oluşmuşsa bile puanı 0 kalmalı
      expect(users.currentUser?.points ?? 0, 0);
    });

    test('updateUser telefon değişince kaydı yeni key altına taşır', () async {
      final users = UserProvider();
      final user = newUser(phone: '5550001');
      await users.addUser(user);
      final stored = Hive.box<User>('user_box').get('5550001')!;

      await users.updateUser(
        stored,
        name: 'Ali',
        surname: 'Veli',
        phone: '5559999',
        image: '',
        points: 0,
        note: '',
      );

      final box = Hive.box<User>('user_box');
      expect(box.get('5550001'), isNull);
      expect(box.get('5559999'), isNotNull);
      expect(box.get('5559999')!.phone, '5559999');
    });
  });
}
