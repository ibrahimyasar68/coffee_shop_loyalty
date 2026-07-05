import 'package:coffee_shop_loyalty/l10n/app_localizations.dart';
import 'package:coffee_shop_loyalty/models/coffee_model.dart';
import 'package:coffee_shop_loyalty/providers/product_provider.dart';
import 'package:coffee_shop_loyalty/providers/user_provider.dart';
import 'package:coffee_shop_loyalty/screens/add_product_screen.dart';
import 'package:coffee_shop_loyalty/screens/admin_gate_screen.dart';
import 'package:coffee_shop_loyalty/screens/order_history_screen.dart';
import 'package:coffee_shop_loyalty/screens/reward_screen.dart';
import 'package:coffee_shop_loyalty/screens/settings_screen.dart';
import 'package:coffee_shop_loyalty/screens/welcome_screen.dart';
import 'package:coffee_shop_loyalty/theme/app_theme.dart';
import 'package:coffee_shop_loyalty/widgets/animations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // En ucuz ödülün puan maliyeti (hiç ürün yoksa null)
  int? _cheapestRewardCost(BuildContext context) {
    final products = context.watch<ProductProvider>().allItems;
    if (products.isEmpty) return null;
    return products.map(productRewardCost).reduce((a, b) => a < b ? a : b);
  }

  // Puana göre rozet seviyesi
  Map<String, dynamic> _getBadge(int points, AppLocalizations l) {
    if (points >= 500) {
      return {'label': l.badgeMaster, 'color': const Color(0xFFB8860B)};
    } else if (points >= 200) {
      return {'label': l.badgeLover, 'color': AppColors.mocha};
    } else if (points >= 50) {
      return {'label': l.badgeRegular, 'color': const Color(0xFF6B7280)};
    } else {
      return {'label': l.badgeNew, 'color': AppColors.muted};
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final user = context.watch<UserProvider>().currentUser;
    final points = user?.points ?? 0;
    final badge = _getBadge(points, l);

    // Bir sonraki seviyeye kaç puan kaldı
    int nextLevel = 50;
    if (points >= 500) {
      nextLevel = 500;
    } else if (points >= 200) {
      nextLevel = 500;
    } else if (points >= 50) {
      nextLevel = 200;
    }
    final double progress = (points / nextLevel).clamp(0.0, 1.0);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── HEADER ──────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: AppColors.espresso,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Kahve doku arka plan
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.espresso,
                          AppColors.coffee,
                          AppColors.mocha,
                        ],
                      ),
                    ),
                  ),
                  // Dekoratif daireler
                  Positioned(
                    top: -30,
                    right: -30,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.05),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 30,
                    left: -20,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.04),
                      ),
                    ),
                  ),
                  // Avatar + isim
                  Positioned(
                    bottom: 24,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        // Avatar
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.caramel,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                              width: 3,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              user != null && user.name.isNotEmpty
                                  ? user.name[0].toUpperCase()
                                  : 'M',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: AppColors.espresso,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${user?.name ?? l.guest} ${user?.surname ?? l.member}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 3),
                          decoration: BoxDecoration(
                            color: (badge['color'] as Color)
                                .withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: (badge['color'] as Color)
                                  .withValues(alpha: 0.6),
                            ),
                          ),
                          child: Text(
                            badge['label'] as String,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── İÇERİK ──────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // PUAN KARTI
                  _PointsCard(
                    points: points,
                    progress: progress,
                    nextLevel: nextLevel,
                    // En ucuz ödülün puan maliyeti (filtreden bağımsız)
                    cheapestReward: _cheapestRewardCost(context),
                    // Ödül sayfası yalnızca kayıtlı üye girişinde açılır
                    onOpenRewards: context.watch<UserProvider>().isLoggedIn
                        ? () => Navigator.push(
                              context,
                              fadeThroughRoute(const RewardScreen()),
                            )
                        : null,
                  ),
                  const SizedBox(height: 20),

                  // BİLGİLER
                  Text(
                    l.accountInfo,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: context.inkStrong,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _InfoCard(
                    icon: Icons.person_outline,
                    label: l.fullName,
                    value: '${user?.name ?? '-'} ${user?.surname ?? ''}',
                  ),
                  _InfoCard(
                    icon: Icons.phone_outlined,
                    label: l.phone,
                    value: user?.phone.isNotEmpty == true
                        ? user!.phone
                        : l.notSpecified,
                  ),
                  _InfoCard(
                    icon: Icons.sticky_note_2_outlined,
                    label: l.note,
                    value:
                        user?.note.isNotEmpty == true ? user!.note : l.noNote,
                  ),
                  const SizedBox(height: 28),

                  // SİPARİŞ GEÇMİŞİ BUTONU
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.push(
                        context,
                        fadeThroughRoute(const OrderHistoryScreen()),
                      ),
                      icon: const Icon(Icons.receipt_long_outlined,
                          color: Colors.white, size: 20),
                      label: Text(
                        l.orderHistory,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.coffee,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // YÖNETİM & AYARLAR
                  Text(
                    l.manageSection,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: context.inkStrong,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _MenuTile(
                    icon: Icons.add_circle_outline,
                    label: l.newProduct,
                    onTap: () => Navigator.push(
                      context,
                      fadeThroughRoute(const AddProductScreen()),
                    ),
                  ),
                  _MenuTile(
                    icon: Icons.admin_panel_settings_outlined,
                    label: l.adminPanel,
                    onTap: () => Navigator.push(
                      context,
                      fadeThroughRoute(const AdminGateScreen()),
                    ),
                  ),
                  _MenuTile(
                    icon: Icons.settings_outlined,
                    label: l.settingsTitle,
                    onTap: () => Navigator.push(
                      context,
                      fadeThroughRoute(const SettingsScreen()),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ÇIKIŞ BUTONU
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        context.read<UserProvider>().loginAsGuest();
                        Navigator.pushAndRemoveUntil(
                          context,
                          fadeThroughRoute(const WelcomeScreen()),
                          (route) => false,
                        );
                      },
                      icon: const Icon(Icons.logout,
                          color: AppColors.mocha, size: 20),
                      label: Text(
                        l.logout,
                        style: const TextStyle(
                          color: AppColors.mocha,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.mocha),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── PUAN KARTI ────────────────────────────────────────────────
class _PointsCard extends StatelessWidget {
  final int points;
  final double progress;
  final int nextLevel;
  final int? cheapestReward;
  final VoidCallback? onOpenRewards;

  const _PointsCard({
    required this.points,
    required this.progress,
    required this.nextLevel,
    this.cheapestReward,
    this.onOpenRewards,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.coffee, AppColors.espresso],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.espresso.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l.totalPoints,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  letterSpacing: 0.5,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.caramel.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  l.loyaltyTag,
                  style:
                      const TextStyle(color: AppColors.caramel, fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Puan 0'dan hedefe doğru sayar
          AnimatedCount(
            value: points,
            builder: (context, v) => Text(
              '$v P',
              style: const TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // İlerleme çubuğu 0'dan değerine yumuşakça dolar
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: progress),
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) => ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: value,
                minHeight: 8,
                backgroundColor: Colors.white.withValues(alpha: 0.15),
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.caramel),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            points >= 500
                ? l.maxLevel
                : l.pointsToNextLevel(nextLevel - points),
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),

          // ── ÖDÜL HEDEFİ ────────────────────────────────────
          const SizedBox(height: 16),
          Divider(color: Colors.white.withValues(alpha: 0.12), height: 1),
          const SizedBox(height: 14),
          _RewardGoal(
            points: points,
            cheapestReward: cheapestReward,
            onOpenRewards: onOpenRewards,
          ),
        ],
      ),
    );
  }
}

// ── ÖDÜL HEDEFİ ────────────────────────────────────────────────
// En ucuz ödüle (en düşük fiyatlı ürünün puan maliyeti) göre ilerleme.
class _RewardGoal extends StatelessWidget {
  final int points;
  final int? cheapestReward; // en ucuz ödülün puan maliyeti; null = ürün yok
  final VoidCallback? onOpenRewards; // ödül sayfasını aç (kayıtlı üye)
  const _RewardGoal({
    required this.points,
    this.cheapestReward,
    this.onOpenRewards,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final target = cheapestReward;
    // Ürün yoksa ödül bölümünü hiç gösterme
    if (target == null) return const SizedBox.shrink();

    final ready = points >= target; // en az bir ödül alınabilir
    final remaining = ready ? 0 : target - points;
    final goalProgress = ready ? 1.0 : points / target;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.card_giftcard_rounded,
                color: AppColors.caramel, size: 16),
            const SizedBox(width: 6),
            Text(
              l.rewardGoal,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Text('$points/$target',
                style: const TextStyle(color: Colors.white54, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 8),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: goalProgress.clamp(0.0, 1.0)),
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeOutCubic,
          builder: (context, value, _) => ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 8,
              backgroundColor: Colors.white.withValues(alpha: 0.15),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          ready ? l.freeCoffeeReady : l.pointsToFreeCoffee(remaining),
          style: TextStyle(
            color: ready ? AppColors.caramel : Colors.white54,
            fontSize: 12,
            fontWeight: ready ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        // Ödül alınabiliyorsa ve üye girişi yapıldıysa ödül sayfası butonu
        if (ready && onOpenRewards != null) ...[
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton.icon(
              onPressed: onOpenRewards,
              icon: const Icon(Icons.card_giftcard_rounded, size: 18),
              label: Text(
                l.viewRewards,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.caramel,
                foregroundColor: AppColors.espresso,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// ── BİLGİ SATIRI ──────────────────────────────────────────────
class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: context.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.espresso.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: context.softFill,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.mocha, size: 20),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.muted,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: context.inkStrong,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── YÖNETİM/AYAR SATIRI ───────────────────────────────────────
class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: context.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        boxShadow: context.cardShadow,
      ),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        leading: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: context.softFill,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.mocha, size: 20),
        ),
        title: Text(label,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: context.inkStrong)),
        trailing: const Icon(Icons.chevron_right, color: AppColors.muted),
      ),
    );
  }
}
