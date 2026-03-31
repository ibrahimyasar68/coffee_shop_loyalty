import 'package:coffee_shop_loyalty/screens/cart_screen.dart';
import 'package:coffee_shop_loyalty/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: double.infinity,
      color: Colors.grey.shade200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          MaterialButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => WelcomeScreen()),
              );
            },
            child: Column(
              children: [
                Icon(Icons.home_outlined, size: 25),
                Text('Ana Sayfa'),
              ],
            ),
          ),

          MaterialButton(
            onPressed: () {},
            child: Column(
              children: [
                Icon(Icons.person_2_outlined, size: 20),
                Text('Hesabım'),
              ],
            ),
          ),

          MaterialButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartScreen()),
              );
            },
            child: Column(
              children: [
                Icon(Icons.shopping_basket_outlined, size: 20),
                Text('Sepetim'),
              ],
            ),
          ),

          MaterialButton(
            onPressed: () {},
            child: Column(
              children: [
                Icon(Icons.favorite_border_outlined, size: 20),
                Text('Favoriler'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
