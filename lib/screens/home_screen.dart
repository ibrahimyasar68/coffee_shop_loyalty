import 'package:coffee_shop_loyalty/providers/cart_provider.dart';
import 'package:coffee_shop_loyalty/providers/product_provider.dart';
import 'package:coffee_shop_loyalty/providers/user_provider.dart';
import 'package:coffee_shop_loyalty/screens/add_product_screen.dart';
import 'package:coffee_shop_loyalty/screens/cart_screen.dart';
import 'package:coffee_shop_loyalty/widgets/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final userProvider = context.watch<UserProvider>();

    return Scaffold(
      bottomNavigationBar: BottomBar(),
      appBar: AppBar(
        leading: Center(
          child: Column(
            children: [
              Text(
                " ${userProvider.currentUser?.name} ",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                " ${userProvider.currentUser?.surname} ",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        title: const Text("Coffee Shop"),
        centerTitle: true,
        actions: [
          Text(
            "${userProvider.currentUser?.points ?? 20} P",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Consumer<CartProvider>(
            builder: (context, cart, child) => Badge(
              label: Text(cart.cart.length.toString()),
              isLabelVisible: cart.cart.isNotEmpty,
              child: IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (c) => const CartScreen()),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Kahve ara...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (v) => context.read<ProductProvider>().updateSearch(v),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: productProvider.items.length,
              itemBuilder: (context, index) {
                final coffee = productProvider.items[index];
                return Card(
                  child: ListTile(
                    leading: Image.network(
                      coffee.imagePath,
                      width: 50,
                      errorBuilder: (c, e, s) => const Icon(Icons.coffee),
                    ),
                    title: Text(coffee.name),
                    subtitle: Text("${coffee.price} TL"),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.add_shopping_cart,
                        color: Colors.brown,
                      ),
                      onPressed: () {
                        context.read<CartProvider>().addToCart(coffee);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("${coffee.name} sepete eklendi!"),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProductScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
