import 'package:cached_network_image/cached_network_image.dart';
import 'package:coffee_shop_loyalty/l10n/app_localizations.dart';
import 'package:coffee_shop_loyalty/l10n/l10n_helpers.dart';
import 'package:coffee_shop_loyalty/models/coffee_model.dart';
import 'package:coffee_shop_loyalty/providers/cart_provider.dart';
import 'package:coffee_shop_loyalty/providers/product_provider.dart';
import 'package:coffee_shop_loyalty/providers/user_provider.dart';
import 'package:coffee_shop_loyalty/screens/product_detail_screen.dart';
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

            // ── ÜRÜN GRID ────────────────────────────────────────
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
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.70,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final coffee = products[index];
                        return FadeSlideIn(
                          key: ValueKey('card_${coffee.key}_$index'),
                          delay: Duration(milliseconds: 50 * (index % 6)),
                          child: _ProductGridCard(coffee: coffee),
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
// ÜRÜN GRID KARTI — sade, hızlı-ekle (varsayılan Orta boyut)
// ══════════════════════════════════════════════════════════════
class _ProductGridCard extends StatelessWidget {
  final Coffee coffee;
  const _ProductGridCard({required this.coffee});

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
        decoration: BoxDecoration(
          color: context.surfaceCard,
          borderRadius: BorderRadius.circular(16),
          boxShadow: context.cardShadow,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Görsel
            AspectRatio(
              aspectRatio: 1.35,
              child: CachedNetworkImage(
                imageUrl: coffee.imagePath,
                fit: BoxFit.cover,
                placeholder: (_, __) =>
                    Container(color: context.imagePlaceholder),
                errorWidget: (_, __, ___) => Container(
                  color: AppColors.coffee,
                  child:
                      const Icon(Icons.coffee, color: Colors.white54, size: 32),
                ),
              ),
            ),
            // Bilgi
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      coffee.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: context.inkStrong,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${l.categoryLabel(coffee.category)} · +${coffee.points} P',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          const TextStyle(fontSize: 11, color: AppColors.muted),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          formatPrice(coffee.price),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: context.inkStrong,
                          ),
                        ),
                        ScaleTap(
                          onTap: () => _quickAdd(context, l),
                          child: Container(
                            width: 40,
                            height: 40,
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
                                size: 22),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
