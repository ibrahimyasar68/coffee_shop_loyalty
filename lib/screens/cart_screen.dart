import 'package:cached_network_image/cached_network_image.dart';
import 'package:coffee_shop_loyalty/providers/cart_provider.dart';
import 'package:coffee_shop_loyalty/providers/order_provider.dart';
import 'package:coffee_shop_loyalty/providers/user_provider.dart';
import 'package:coffee_shop_loyalty/l10n/app_localizations.dart';
import 'package:coffee_shop_loyalty/l10n/l10n_helpers.dart';
import 'package:coffee_shop_loyalty/screens/order_success_screen.dart';
import 'package:coffee_shop_loyalty/theme/app_theme.dart';
import 'package:coffee_shop_loyalty/utils/format.dart';
import 'package:coffee_shop_loyalty/widgets/animations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cartProvider = context.watch<CartProvider>();
    final cartItems = cartProvider.cart;
    final lines = cartProvider.groupedCart;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.espresso,
        flexibleSpace: const DecoratedBox(
          decoration: BoxDecoration(gradient: AppColors.headerGradient),
        ),
        title: Text(l.cartTitle,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: cartItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.coffee_outlined,
                      size: 64, color: AppColors.caramel),
                  const SizedBox(height: 12),
                  Text(l.cartEmpty,
                      style: const TextStyle(
                          color: AppColors.muted, fontSize: 16)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
              itemCount: lines.length,
              itemBuilder: (context, index) {
                final line = lines[index];
                final item = line.sample;
                return FadeSlideIn(
                  key: ValueKey('cart_${line.key}'),
                  delay: Duration(milliseconds: 60 * index),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: context.surfaceCard,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: context.cardShadow,
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: item.imagePath,
                            width: 52,
                            height: 52,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Container(
                                width: 52,
                                height: 52,
                                color: context.imagePlaceholder),
                            errorWidget: (_, __, ___) => Container(
                              width: 52,
                              height: 52,
                              color: AppColors.coffee,
                              child: const Icon(Icons.coffee,
                                  color: Colors.white54, size: 22),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Ad + fiyat
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.size == 'Orta'
                                    ? item.name
                                    : '${item.name} (${l.size(item.size)})',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: context.inkStrong),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${formatPrice(line.lineTotal)}  ·  +${item.points * line.quantity}p',
                                style: TextStyle(
                                    color: context.inkMedium,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        // Adet stepper
                        _QtyStepper(
                          quantity: line.quantity,
                          onMinus: () =>
                              context.read<CartProvider>().decrementLine(line),
                          onPlus: () =>
                              context.read<CartProvider>().incrementLine(line),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.surfaceCard,
          boxShadow: [
            BoxShadow(
              color: AppColors.espresso.withValues(alpha: 0.1),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Özet satırı
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l.totalAmount,
                    style:
                        const TextStyle(color: AppColors.muted, fontSize: 13)),
                Text(
                  formatPrice(cartProvider.totalCartPrice),
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: context.inkStrong),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l.pointsToEarn,
                    style:
                        const TextStyle(color: AppColors.muted, fontSize: 13)),
                Text(
                  '+${cartProvider.earnedPoints} P',
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.mocha),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Sipariş tamamla butonu
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: cartItems.isEmpty
                    ? null
                    : () async {
                        final userProvider = context.read<UserProvider>();
                        final cartProvider = context.read<CartProvider>();
                        final orderProvider = context.read<OrderProvider>();

                        final userName =
                            '${userProvider.currentUser?.name ?? 'Misafir'} '
                            '${userProvider.currentUser?.surname ?? ''}';

                        // Onay ekranında göstermek için özet bilgileri sakla
                        final earned = cartProvider.earnedPoints;

                        // 1. Siparişi geçmişe kaydet
                        await orderProvider.saveOrder(
                          cartItems: cartProvider.cart,
                          userName: userName.trim(),
                        );

                        // 2. Puan ekle  3. Sepeti temizle
                        userProvider.addPoints(earned);
                        await cartProvider.clearCart();

                        // 4. Onay ekranına geç
                        if (context.mounted) {
                          Navigator.pushReplacement(
                            context,
                            fadeThroughRoute(
                                OrderSuccessScreen(earnedPoints: earned)),
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.espresso,
                  disabledBackgroundColor: const Color(0xFFE5DDD5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  l.completeOrder,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── ADET STEPPER (− miktar +) ─────────────────────────────────
class _QtyStepper extends StatelessWidget {
  final int quantity;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  const _QtyStepper({
    required this.quantity,
    required this.onMinus,
    required this.onPlus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.softFill,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _btn(
            icon: quantity > 1 ? Icons.remove : Icons.delete_outline,
            color: quantity > 1 ? context.inkMedium : Colors.red,
            onTap: onMinus,
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 22),
            child: Text(
              '$quantity',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: context.inkStrong),
            ),
          ),
          _btn(icon: Icons.add, color: context.inkMedium, onTap: onPlus),
        ],
      ),
    );
  }

  Widget _btn({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Icon(icon, size: 20, color: color),
      ),
    );
  }
}
