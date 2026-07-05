import 'package:cached_network_image/cached_network_image.dart';
import 'package:coffee_shop_loyalty/l10n/app_localizations.dart';
import 'package:coffee_shop_loyalty/models/coffee_model.dart';
import 'package:coffee_shop_loyalty/providers/order_provider.dart';
import 'package:coffee_shop_loyalty/providers/product_provider.dart';
import 'package:coffee_shop_loyalty/providers/user_provider.dart';
import 'package:coffee_shop_loyalty/theme/app_theme.dart';
import 'package:coffee_shop_loyalty/widgets/animations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Ödül kullanma sayfası — müşteri puanına göre ürünleri ödül olarak alır.
/// Puan maliyeti = ürünün fiyatı (1 TL = 1 puan, bkz. productRewardCost).
class RewardScreen extends StatelessWidget {
  const RewardScreen({super.key});

  Future<void> _redeem(BuildContext context, Coffee coffee, int cost) async {
    final l = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l.redeemReward),
        content: Text(l.redeemConfirmMessage(coffee.name, cost)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(minimumSize: const Size(88, 44)),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l.rewardUse),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;

    final userProvider = context.read<UserProvider>();
    final orderProvider = context.read<OrderProvider>();
    final user = userProvider.currentUser;
    final name = '${user?.name ?? ''} ${user?.surname ?? ''}'.trim();

    if (userProvider.redeemProduct(cost)) {
      await orderProvider.saveRewardRedemption(
        userName: name,
        itemName: l.freeItemPrefix(coffee.name),
        imagePath: coffee.imagePath,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.rewardRedeemed(coffee.name))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final points = context.watch<UserProvider>().currentUser?.points ?? 0;

    // Tüm ürünler, puan maliyetine göre ucuzdan pahalıya sıralı
    final products = context.watch<ProductProvider>().allItems
      ..sort((a, b) => productRewardCost(a).compareTo(productRewardCost(b)));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.espresso,
        flexibleSpace: const DecoratedBox(
          decoration: BoxDecoration(gradient: AppColors.headerGradient),
        ),
        title: Text(l.rewardsTitle,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // ── PUAN BAŞLIĞI ─────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            decoration: const BoxDecoration(gradient: AppColors.ctaGradient),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$points',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        height: 1,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 6),
                      child: Text('P',
                          style: TextStyle(
                              color: AppColors.caramel,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  l.rewardsHint(points),
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8), fontSize: 13),
                ),
              ],
            ),
          ),

          // ── ÖDÜL LİSTESİ ─────────────────────────────────────
          Expanded(
            child: products.isEmpty
                ? _EmptyRewards()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final coffee = products[index];
                      final cost = productRewardCost(coffee);
                      final affordable = points >= cost;
                      return FadeSlideIn(
                        key: ValueKey('reward_${coffee.key}'),
                        delay: Duration(milliseconds: 40 * index),
                        child: _RewardRow(
                          coffee: coffee,
                          cost: cost,
                          affordable: affordable,
                          missing: cost - points,
                          onRedeem: () => _redeem(context, coffee, cost),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ── ÖDÜL SATIRI ───────────────────────────────────────────────
class _RewardRow extends StatelessWidget {
  final Coffee coffee;
  final int cost;
  final bool affordable;
  final int missing; // alınamıyorsa gereken ek puan
  final VoidCallback onRedeem;

  const _RewardRow({
    required this.coffee,
    required this.cost,
    required this.affordable,
    required this.missing,
    required this.onRedeem,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Opacity(
      opacity: affordable ? 1 : 0.55,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: context.surfaceCard,
          borderRadius: BorderRadius.circular(14),
          boxShadow: context.cardShadow,
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: coffee.imagePath,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                    width: 56, height: 56, color: context.imagePlaceholder),
                errorWidget: (_, __, ___) => Container(
                  width: 56,
                  height: 56,
                  color: AppColors.coffee,
                  child: const Icon(Icons.coffee, color: Colors.white54),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    coffee.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: context.inkStrong),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.card_giftcard_rounded,
                          size: 14, color: AppColors.mocha),
                      const SizedBox(width: 4),
                      Text(
                        l.rewardCostLabel(cost),
                        style: const TextStyle(
                            color: AppColors.mocha,
                            fontWeight: FontWeight.w600,
                            fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Alınabiliyorsa "Kullan", değilse eksik puan rozeti
            if (affordable)
              SizedBox(
                height: 40,
                child: ElevatedButton(
                  onPressed: onRedeem,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.caramel,
                    foregroundColor: AppColors.espresso,
                    minimumSize: const Size(64, 40),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(l.rewardUse,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              )
            else
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: context.softFill,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.lock_outline,
                        size: 13, color: AppColors.muted),
                    const SizedBox(width: 4),
                    Text(
                      l.rewardPointsMore(missing),
                      style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.muted,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── BOŞ DURUM ─────────────────────────────────────────────────
class _EmptyRewards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.card_giftcard_outlined,
                size: 64, color: AppColors.caramel),
            const SizedBox(height: 16),
            Text(
              l.rewardsEmpty,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: context.inkStrong),
            ),
            const SizedBox(height: 8),
            Text(
              l.rewardsEmptyHint,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: AppColors.muted),
            ),
          ],
        ),
      ),
    );
  }
}
