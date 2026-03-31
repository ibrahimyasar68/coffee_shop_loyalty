import 'package:coffee_shop_loyalty/models/coffee_model.dart';
import 'package:coffee_shop_loyalty/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  // Form kontrolcüleri
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _pointsController = TextEditingController();
  final _categoryController = TextEditingController();
  final _imageController = TextEditingController();
  final _noteController = TextEditingController();

  void _saveProduct() {
    if (_nameController.text.isEmpty || _priceController.text.isEmpty) return;

    // 1. Yeni bir Coffee nesnesi oluşturuyoruz
    final newCoffee = Coffee(
      id: DateTime.now()
          .millisecondsSinceEpoch, // Benzersiz bir ID üretmek için
      name: _nameController.text,
      price: double.parse(_priceController.text),
      points: int.parse(_pointsController.text),
      category: _categoryController.text,
      imagePath: _imageController.text.isEmpty
          ? "https://images.unsplash.com/photo-1509042239860-f550ce710b93" // Boşsa varsayılan görsel
          : _imageController.text,
      note: _noteController.text.isEmpty ? " " : _nameController.text,
    );

    // 2. Provider üzerinden Hive'a kaydediyoruz
    context.read<ProductProvider>().addProduct(newCoffee);

    // 3. Ekranı kapatıyoruz
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Yeni Ürün Ekle")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Ürün Adı"),
              ),
              TextField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: "Fiyat"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _pointsController,
                decoration: const InputDecoration(labelText: "Puan"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  labelText: "Kategori (sıcak/soğuk/tatlı)",
                ),
              ),
              TextField(
                controller: _imageController,
                decoration: const InputDecoration(labelText: "Görsel URL"),
              ),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Not:"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProduct,
                child: const Text("Ürünü Kaydet"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
