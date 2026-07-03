import 'package:coffee_shop_loyalty/models/coffee_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

/// Sepette aynı ürün+boyut kombinasyonunu adetiyle birlikte temsil eder.
class CartLine {
  final Coffee sample; // temsilci öğe (fiyat/puan/görsel/boyut)
  final int quantity;
  const CartLine(this.sample, this.quantity);

  String get key => '${sample.name}|${sample.size}';
  double get lineTotal => sample.price * quantity;
}

class CartProvider extends ChangeNotifier {
  Box<Coffee> get _cartBox => Hive.box<Coffee>('cart_box');

  List<Coffee> get cart => _cartBox.values.toList();

  // Aynı ürün+boyut öğelerini adetiyle gruplar (sepet ekranı için)
  List<CartLine> get groupedCart {
    final Map<String, List<Coffee>> groups = {};
    for (final c in _cartBox.values) {
      groups.putIfAbsent('${c.name}|${c.size}', () => []).add(c);
    }
    return groups.values.map((items) => CartLine(items.first, items.length)).toList();
  }

  // Boyutlu ekleme — fiyat ve puan boyuta göre hesaplanır
  // Küçük: -%10 | Orta: 0 | Büyük: +%10
  // Boyut artık isme gömülmez; ayrı `size` alanında tutulur.
  void addToCartWithSize(Coffee coffee, String size) {
    final multiplier = _sizeMultiplier(size);

    final newCopy = Coffee(
      id: coffee.id,
      category: coffee.category,
      name: coffee.name,
      price: double.parse((coffee.price * multiplier).toStringAsFixed(2)),
      imagePath: coffee.imagePath,
      points: (coffee.points * multiplier).round(),
      note: coffee.note,
      size: size,
    );
    _cartBox.add(newCopy);
    notifyListeners();
  }

  double _sizeMultiplier(String size) {
    switch (size) {
      case 'Küçük':
        return 0.90;
      case 'Büyük':
        return 1.10;
      default:
        return 1.00; // Orta
    }
  }

  Future<void> removeFromCart(Coffee coffee) async {
    await coffee.delete();
    notifyListeners();
  }

  // Adet artır — satırın temsilcisinin birebir kopyasını ekler
  void incrementLine(CartLine line) {
    final s = line.sample;
    _cartBox.add(Coffee(
      id: s.id,
      category: s.category,
      name: s.name,
      price: s.price,
      imagePath: s.imagePath,
      points: s.points,
      note: s.note,
      size: s.size,
    ));
    notifyListeners();
  }

  // Adet azalt — bu satırdan (aynı ad+boyut) bir öğe siler
  Future<void> decrementLine(CartLine line) async {
    Coffee? match;
    for (final c in _cartBox.values) {
      if (c.name == line.sample.name && c.size == line.sample.size) {
        match = c;
        break;
      }
    }
    await match?.delete();
    notifyListeners();
  }

  // Temizleme diskte gerçekleştiğinden Future döner; çağıran isterse
  // await edebilir (UI tarafında fire-and-forget kullanımı da güvenli).
  Future<void> clearCart() async {
    await _cartBox.clear();
    notifyListeners();
  }

  double get totalCartPrice =>
      _cartBox.values.fold(0, (sum, item) => sum + item.price);

  int get earnedPoints =>
      _cartBox.values.fold(0, (sum, item) => sum + item.points);
}
