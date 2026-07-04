import 'package:coffee_shop_loyalty/models/coffee_model.dart';
import 'package:coffee_shop_loyalty/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class OrderProvider extends ChangeNotifier {
  Box<Order>? get _orderBox {
    if (Hive.isBoxOpen('order_box')) {
      return Hive.box<Order>('order_box');
    }
    return null;
  }

  // Tüm siparişler — en yeniden en eskiye
  List<Order> get allOrders {
    final orders = _orderBox?.values.toList() ?? [];
    orders.sort((a, b) => b.date.compareTo(a.date));
    return orders;
  }

  // Belirli kullanıcının siparişleri
  List<Order> ordersForUser(String userName) {
    return allOrders.where((o) => o.userName == userName).toList();
  }

  // Sipariş kaydet — cart_screen'deki "Siparişi Tamamla" butonunda çağrılır
  Future<void> saveOrder({
    required List<Coffee> cartItems,
    required String userName,
  }) async {
    final box = _orderBox;
    if (box == null || cartItems.isEmpty) return;

    // Sepetteki ürünleri grupla (aynı ürün + aynı boyut varsa quantity artır)
    // Boyut isimden ayrı olduğundan, farklı boyutların yanlışlıkla
    // birleşmemesi için anahtar isim+boyut'tan oluşturulur.
    final Map<String, OrderItem> grouped = {};
    for (final coffee in cartItems) {
      final key = '${coffee.name}|${coffee.size}';
      if (grouped.containsKey(key)) {
        grouped[key]!.quantity += 1;
      } else {
        grouped[key] = OrderItem(
          coffeeName: coffee.name,
          price: coffee.price,
          points: coffee.points,
          imagePath: coffee.imagePath,
          quantity: 1,
          size: coffee.size,
        );
      }
    }

    final order = Order(
      date: DateTime.now(),
      items: grouped.values.toList(),
      totalPrice: cartItems.fold(0, (s, c) => s + c.price),
      totalPoints: cartItems.fold(0, (s, c) => s + c.points),
      userName: userName,
    );

    await box.add(order);
    notifyListeners();
  }

  /// Ödül kullanımını geçmişe kaydeder — 0 TL'lik, tek satırlık sipariş.
  /// [itemName] görüntülenecek metin olarak çağıran taraftan (yerelleşmiş)
  /// gelir; geçmişte kalıcı olduğundan kayıt anındaki dille saklanır.
  Future<void> saveRewardRedemption({
    required String userName,
    required String itemName,
  }) async {
    final box = _orderBox;
    if (box == null) return;

    final order = Order(
      date: DateTime.now(),
      items: [
        OrderItem(
          coffeeName: itemName,
          price: 0,
          points: 0,
          imagePath: '',
          quantity: 1,
        ),
      ],
      totalPrice: 0,
      totalPoints: 0,
      userName: userName,
    );

    await box.add(order);
    notifyListeners();
  }

  // Tüm geçmişi temizle
  Future<void> clearAll() async {
    await _orderBox?.clear();
    notifyListeners();
  }
}
