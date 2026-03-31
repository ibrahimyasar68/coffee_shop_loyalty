import 'package:coffee_shop_loyalty/models/coffee_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ProductProvider extends ChangeNotifier {
  // Getter kullanımı en doğru yöntem
  Box<Coffee> get _coffeeBox => Hive.box<Coffee>('coffee_box');

  String _searchQuery = "";

  List<Coffee> get items {
    if (!_coffeeBox.isOpen) return []; // Kutu açık değilse boş liste dön
    final allCoffees = _coffeeBox.values.toList();
    if (_searchQuery.isEmpty) return allCoffees;

    return allCoffees
        .where((c) => c.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  ProductProvider() {
    // Uygulama ayağa kalkarken Hive'a bir nefes payı bırakıyoruz
    Future.microtask(() => _initData());
  }

  void _initData() {
    if (_coffeeBox.isEmpty) {
      _coffeeBox.addAll([
        Coffee(
          id: 1,
          name: "Espresso",
          price: 60.0,
          imagePath:
              "https://images.unsplash.com/photo-1510591509098-f4fdc6d0ff04",
          points: 5,
          note: "",
          category: "sıcak",
        ),
        Coffee(
          id: 2,
          name: "Latte",
          price: 85.0,
          imagePath:
              "https://images.unsplash.com/photo-1536939459926-301728717817",
          points: 10,
          note: "",
          category: "sıcak",
        ),
        Coffee(
          id: 3,
          name: "Cappuccino",
          price: 80.0,
          imagePath:
              "https://images.unsplash.com/photo-1572442388796-11668a67e53d",
          points: 8,
          note: "",
          category: "sıcak",
        ),
      ]);
      notifyListeners();
    }
  }

  void updateSearch(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> addProduct(Coffee coffee) async {
    await _coffeeBox.add(coffee); // Hive'a asıl kaydı yapan satır
    notifyListeners(); // Arayüzün yeni ürünü görmesini sağlar
  }

  // Silme özelliği de olsun, lazım olur:
  Future<void> deleteProduct(Coffee coffee) async {
    await coffee.delete();
    notifyListeners();
  }
}
