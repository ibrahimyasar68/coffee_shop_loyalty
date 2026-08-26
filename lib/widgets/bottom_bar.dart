import 'package:coffee_shop_loyalty/providers/cart_provider.dart';
import 'package:coffee_shop_loyalty/screens/cart_screen.dart';
import 'package:coffee_shop_loyalty/screens/home_screen.dart';
import 'package:coffee_shop_loyalty/screens/profile_screen.dart';
import 'package:coffee_shop_loyalty/l10n/app_localizations.dart';
import 'package:coffee_shop_loyalty/theme/app_theme.dart';
import 'package:coffee_shop_loyalty/widgets/ad_banner.dart';
import 'package:coffee_shop_loyalty/widgets/animations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomBar extends StatelessWidget {
  /// Aktif sekme: 0=Ana Sayfa, 1=Profilim, 2=Sepetim, -1=hiçbiri
  final int current;
  const BottomBar({super.key, this.current = -1});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    // Banner reklam çubuğun hemen üstünde, tüm sekmelerde sabit kalır.
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const AdBanner(),
        _NavBar(l: l, current: current),
      ],
    );
  }
}

class _NavBar extends StatelessWidget {
  final AppLocalizations l;
  final int current;
  const _NavBar({required this.l, required this.current});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.espresso,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 62,
          child: Row(
            children: [
              Expanded(
                child: _BarButton(
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_rounded,
                  label: l.navHome,
                  active: current == 0,
                  // Oturumu koruyarak ana sayfaya dön (çıkış yaptırmadan)
                  onTap: () => Navigator.pushAndRemoveUntil(
                    context,
                    fadeThroughRoute(const HomeScreen()),
                    (route) => false,
                  ),
                ),
              ),
              // Sepetim — ürün sayısı badge ile (Profil ile yer değiştirildi)
              Expanded(
                child: Consumer<CartProvider>(
                  builder: (context, cart, _) => _BarButton(
                    icon: Icons.shopping_basket_outlined,
                    activeIcon: Icons.shopping_basket_rounded,
                    label: l.navCart,
                    active: current == 2,
                    badgeCount: cart.cart.length,
                    onTap: () => Navigator.push(
                      context,
                      fadeThroughRoute(const CartScreen()),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: _BarButton(
                  icon: Icons.person_outline,
                  activeIcon: Icons.person_rounded,
                  label: l.navProfile,
                  active: current == 1,
                  onTap: () => Navigator.push(
                    context,
                    fadeThroughRoute(const ProfileScreen()),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BarButton extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool active;
  final int badgeCount;
  final VoidCallback onTap;

  const _BarButton({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.active,
    required this.onTap,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        active ? AppColors.caramel : AppColors.caramel.withValues(alpha: 0.55);

    Widget iconWidget = Icon(active ? activeIcon : icon, color: color, size: 22);
    if (badgeCount > 0) {
      // Rozet, sayı her değiştiğinde elastik bir zıplamayla vurgulanır.
      // ValueKey(badgeCount) tween'i her değişimde yeniden başlatır.
      iconWidget = TweenAnimationBuilder<double>(
        key: ValueKey(badgeCount),
        tween: Tween(begin: 1.4, end: 1.0),
        duration: const Duration(milliseconds: 400),
        curve: Curves.elasticOut,
        builder: (_, scale, child) =>
            Transform.scale(scale: scale, child: child),
        child: Badge(
          label: Text(
            badgeCount.toString(),
            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
          ),
          backgroundColor: AppColors.caramel,
          textColor: AppColors.espresso,
          child: iconWidget,
        ),
      );
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.symmetric(horizontal: 3),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        decoration: BoxDecoration(
          color: active
              ? AppColors.caramel.withValues(alpha: 0.16)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            iconWidget,
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color,
                fontSize: 9.5,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
