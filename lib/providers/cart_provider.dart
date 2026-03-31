import 'package:coffee_shop_loyalty/models/coffee_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class CartProvider extends ChangeNotifier {
  // Getter kullanımı güvenlidir
  Box<Coffee> get _cartBox => Hive.box<Coffee>('cart_box');

  List<Coffee> get cart => _cartBox.values.toList();

  void addToCart(Coffee coffee) {
    // ÖNEMLİ: Coffee nesnesini kopyalayarak ekliyoruz ki Hive 'key' hatası vermesin
    final newCopy = Coffee(
      id: coffee.id,
      category: coffee.category,
      name: coffee.name,
      price: coffee.price,
      imagePath: coffee.imagePath,
      points: coffee.points,
      note: coffee.note,
    );
    _cartBox.add(newCopy);
    notifyListeners();
  }

  void removeFromCart(Coffee coffee) {
    coffee.delete();
    notifyListeners();
  }

  void clearCart() {
    _cartBox.clear();
    notifyListeners();
  }

  double get totalCartPrice =>
      _cartBox.values.fold(0, (sum, item) => sum + item.price);

  int get earnedPoints =>
      _cartBox.values.fold(0, (sum, item) => sum + item.points);
}
