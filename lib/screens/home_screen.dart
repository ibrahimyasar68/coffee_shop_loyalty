import 'package:cached_network_image/cached_network_image.dart';
import 'package:coffee_shop_loyalty/l10n/app_localizations.dart';
import 'package:coffee_shop_loyalty/l10n/l10n_helpers.dart';
import 'package:coffee_shop_loyalty/models/coffee_model.dart';
import 'package:coffee_shop_loyalty/providers/cart_provider.dart';
import 'package:coffee_shop_loyalty/providers/product_provider.dart';
import 'package:coffee_shop_loyalty/providers/user_provider.dart';
import 'package:coffee_shop_loyalty/screens/product_detail_screen.dart';
import 'package:coffee_shop_loyalty/screens/reward_screen.dart';
import 'package:coffee_shop_loyalty/screens/welcome_screen.dart';
import 'package:coffee_shop_loyalty/theme/app_theme.dart';
import 'package:coffee_shop_loyalty/utils/format.dart';
import 'package:coffee_shop_loyalty/widgets/animations.dart';
import 'package:coffee_shop_loyalty/widgets/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _logout(BuildContext context) {
    context.read<UserProvider>().loginAsGuest();
    Navigator.pushAndRemoveUntil(
      context,
      fadeThroughRoute(const WelcomeScreen()),
      (route) => false,
    );
  }

  // Geri tuşu / çıkış ikonu yanlışlıkla basılabildiğinden önce onay sorulur
  Future<void> _confirmLogout(BuildContext context) async {
    final l = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l.logout),
        content: Text(l.logoutConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(minimumSize: const Size(88, 44)),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l.logout),
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) _logout(context);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final productProvider = context.watch<ProductProvider>();
    final userProvider = context.watch<UserProvider>();
    final user = userProvider.currentUser;
    final products = productProvider.items;

    // Ödül banner'ı: giriş yapan üye, en az bir ürünü puanıyla alabiliyorsa
    // liste başında sabit görünür. Maliyet karşılaştırması filtreden
    // bağımsız tüm ürünler üzerinden yapılır.
    final allProducts = productProvider.allItems;
    final int? cheapestCost = allProducts.isEmpty
        ? null
        : allProducts.map(productRewardCost).reduce((a, b) => a < b ? a : b);
    final canReward = userProvider.isLoggedIn &&
        cheapestCost != null &&
        (user?.points ?? 0) >= cheapestCost;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmLogout(context);
      },
      child: Scaffold(
        bottomNavigationBar: const BottomBar(current: 0),
        appBar: AppBar(
          backgroundColor: AppColors.espresso,
          elevation: 0,
          flexibleSpace: const DecoratedBox(
            decoration: BoxDecoration(gradient: AppColors.headerGradient),
          ),
          leading: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.name ?? l.guest,
                  style: const TextStyle(
                    color: AppColors.caramel,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  user?.surname ?? l.member,
                  style: const TextStyle(color: Colors.white54, fontSize: 11),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          title: Text(
            l.appTitle,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              letterSpacing: 0.5,
            ),
          ),
          centerTitle: true,
          actions: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.caramel.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                l.pointsShort(user?.points ?? 0),
                style: const TextStyle(
                  color: AppColors.caramel,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.logout_rounded, color: Colors.white),
              tooltip: l.logout,
              onPressed: () => _confirmLogout(context),
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── ARAMA ────────────────────────────────────────────
            Container(
              color: AppColors.coffee,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: l.searchHint,
                  hintStyle: const TextStyle(color: Colors.white70),
                  prefixIcon:
                      const Icon(Icons.search, color: Colors.white70, size: 20),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.1),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (v) =>
                    context.read<ProductProvider>().updateSearch(v),
              ),
            ),

            // ── KATEGORİ FİLTRE ÇİPLERİ ──────────────────────────
            _CategoryChips(selected: productProvider.selectedCategory),

            // ── ÖDÜL BANNER (liste başında sabit) ────────────────
            if (canReward) _RewardBanner(points: user?.points ?? 0),

            // ── ÜRÜN LİSTESİ ─────────────────────────────────────
            Expanded(
              child: products.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.coffee,
                              size: 60, color: AppColors.caramel),
                          const SizedBox(height: 12),
                          Text(l.noProducts,
                              style: const TextStyle(color: AppColors.muted)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final coffee = products[index];
                        return FadeSlideIn(
                          key: ValueKey('card_${coffee.key}_$index'),
                          delay: Duration(milliseconds: 40 * (index % 8)),
                          child: _ProductListRow(coffee: coffee),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// KATEGORİ FİLTRE ÇİPLERİ (Tümü + sabit kategoriler)
// ══════════════════════════════════════════════════════════════
class _CategoryChips extends StatelessWidget {
  final String? selected;
  const _CategoryChips({required this.selected});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    // null = Tümü, ardından kanonik kategoriler
    final items = <String?>[null, ...kProductCategories];

    return SizedBox(
      height: 46,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final cat = items[i];
          final isSelected = selected == cat;
          final label = cat == null ? l.menu : l.categoryLabel(cat);
          return GestureDetector(
            onTap: () => context.read<ProductProvider>().setCategory(cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : context.surfaceCard,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : context.softBorder,
                ),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? Theme.of(context).colorScheme.onPrimary
                      : context.inkMedium,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// ÜRÜN LİSTE SATIRI — yatay kart, hızlı-ekle (varsayılan Orta boyut)
// ══════════════════════════════════════════════════════════════
class _ProductListRow extends StatelessWidget {
  final Coffee coffee;
  const _ProductListRow({required this.coffee});

  void _quickAdd(BuildContext context, AppLocalizations l) {
    context.read<CartProvider>().addToCartWithSize(coffee, 'Orta');
    // Boyutsuz ürünlerde (tatlı/diğer) "(Orta)" ibaresi anlamsız olur
    final message = categoryHasSizes(coffee.category)
        ? l.addedToCart(coffee.name, l.size('Orta'))
        : l.addedToCartNoSize(coffee.name);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.espresso,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        fadeThroughRoute(ProductDetailScreen(coffee: coffee)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: context.surfaceCard,
          borderRadius: BorderRadius.circular(16),
          boxShadow: context.cardShadow,
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            // Görsel (sol)
            CachedNetworkImage(
              imageUrl: coffee.imagePath,
              width: 96,
              height: 96,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(
                  width: 96, height: 96, color: context.imagePlaceholder),
              errorWidget: (_, __, ___) => Container(
                width: 96,
                height: 96,
                color: AppColors.coffee,
                child:
                    const Icon(Icons.coffee, color: Colors.white54, size: 32),
              ),
            ),
            // Bilgi (orta)
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      coffee.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: context.inkStrong,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${l.categoryLabel(coffee.category)} · +${coffee.points} P',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          const TextStyle(fontSize: 12, color: AppColors.muted),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      formatPrice(coffee.price),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: context.inkStrong,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Hızlı ekle (sağ)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: ScaleTap(
                onTap: () => _quickAdd(context, l),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: context.isDarkMode
                        ? AppColors.caramel
                        : AppColors.espresso,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.add,
                      color: context.isDarkMode
                          ? AppColors.espresso
                          : AppColors.caramel,
                      size: 24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// ÖDÜL BANNER — liste başında sabit; ödül sayfasına götürür
// ══════════════════════════════════════════════════════════════
class _RewardBanner extends StatelessWidget {
  final int points;
  const _RewardBanner({required this.points});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: ScaleTap(
        onTap: () => Navigator.push(
          context,
          fadeThroughRoute(const RewardScreen()),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            gradient: AppColors.ctaGradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.espresso.withValues(alpha: 0.25),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.caramel.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.card_giftcard_rounded,
                    color: AppColors.caramel, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.rewardBannerTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l.rewardBannerSubtitle(points),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.caramel),
            ],
          ),
        ),
      ),
    );
  }
}
