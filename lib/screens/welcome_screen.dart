import 'dart:ui';
import 'package:coffee_shop_loyalty/screens/add_user_screen.dart';
import 'package:coffee_shop_loyalty/screens/home_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: BottomBar(),
      appBar: AppBar(toolbarHeight: 8),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            backgroundColor: const Color.fromARGB(255, 207, 202, 202),
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                final percent =
                    (constraints.maxHeight - kToolbarHeight) /
                    (400 - kToolbarHeight);
                final blurValue = (1 - percent) * 10;
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset("assets/images/11.jpg", fit: BoxFit.cover),

                    /// 🔥 Blur Layer
                    BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: blurValue,
                        sigmaY: blurValue,
                      ),
                      child: Container(
                        color: Colors.black.withValues(alpha: 0.1),
                      ),
                    ),

                    /// 🔥 Gradient Overlay
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black,
                            Colors.black54,
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),

                    /// 🔥 Title
                    Positioned(
                      bottom: 40,
                      left: 20,
                      right: 20,
                      child: Opacity(
                        opacity: percent.clamp(0.0, 1.0),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Kahve Kokusu",
                              style: TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          /// 🔥 Content
          SliverFillRemaining(
            hasScrollBody: true,
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 53, 38, 38),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Üye Girişi Yap",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 53, 38, 38),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Misafir Girişi Yap",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddUserScreen(),
                        ),
                      );
                    },
                    child: Text('Üye kayıt al'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
