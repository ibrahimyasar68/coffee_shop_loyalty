import 'package:coffee_shop_loyalty/providers/cart_provider.dart';
import 'package:coffee_shop_loyalty/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    // Provider'ı tek bir yerden dinleyelim
    final cartProvider = context.watch<CartProvider>();
    final cartItems =
        cartProvider.cart; // Provider'daki listenin adı 'cart' ise

    return Scaffold(
      appBar: AppBar(title: const Text('Sepetim'), centerTitle: true),
      body: cartItems.isEmpty
          ? const Center(child: Text("Sepetiniz boş ☕"))
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Card(
                  child: ListTile(
                    title: Text(item.name),
                    subtitle: Text("${item.price} TL"),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.remove_shopping_cart_outlined,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        // CartProvider'a bir 'removeFromCart' metodu eklemelisin
                        context.read<CartProvider>().removeFromCart(item);
                      },
                    ),
                  ),
                );
              },
            ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.brown.shade50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'TOPLAM: ${cartProvider.totalCartPrice} TL',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: cartItems.isEmpty
                  ? null
                  : () {
                      // 1. Toplam puanı hesapla (Örn: her ürün 10 puan)
                      // int earnedPoints = cartItems.length * 10;
                      // int showPoint = context.read<CartProvider>().earnedPoints;

                      // 2. UserProvider'a puan ekle
                      context.read<UserProvider>().addPoints(
                        context.read<CartProvider>().earnedPoints,
                      );

                      // 3. Sepeti boşalt
                      context.read<CartProvider>().clearCart();

                      // 4. Geri bildirimi göster
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Sipariş alındı, puanlar yüklendi!"),
                        ),
                      );
                    },
              child: const Text("Siparişi Tamamla"),
            ),
          ],
        ),
      ),
    );
  }
}
