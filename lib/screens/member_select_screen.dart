import 'package:coffee_shop_loyalty/l10n/app_localizations.dart';
import 'package:coffee_shop_loyalty/providers/user_provider.dart';
import 'package:coffee_shop_loyalty/screens/add_user_screen.dart';
import 'package:coffee_shop_loyalty/screens/home_screen.dart';
import 'package:coffee_shop_loyalty/theme/app_theme.dart';
import 'package:coffee_shop_loyalty/widgets/animations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Üye girişi ekranı: kayıtlı üyeleri listeler. Bir üyeye dokununca o
/// üyeyle giriş yapılır. Listenin sonunda her zaman "Misafir Olarak Devam
/// Et" seçeneği bulunur. Hiç kayıtlı üye yoksa yalnızca misafir seçeneği
/// gösterilir.
class MemberSelectScreen extends StatelessWidget {
  const MemberSelectScreen({super.key});

  void _enterHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      fadeThroughRoute(const HomeScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final userProvider = context.watch<UserProvider>();
    final members = userProvider.registeredUsers;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.espresso,
        flexibleSpace: const DecoratedBox(
          decoration: BoxDecoration(gradient: AppColors.headerGradient),
        ),
        title: Text(l.selectMember,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1_outlined),
            tooltip: l.signUp,
            onPressed: () => Navigator.push(
              context,
              fadeThroughRoute(const AddUserScreen()),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          if (members.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 10),
              child: Text(l.tapMemberToLogin,
                  style: const TextStyle(color: AppColors.muted, fontSize: 13)),
            ),

          // Kayıtlı üyeler — kademeli açılış
          ...members.asMap().entries.map((entry) {
            final i = entry.key;
            final user = entry.value;
            return FadeSlideIn(
              key: ValueKey('member_${user.key}'),
              delay: Duration(milliseconds: 50 * i),
              child: _MemberCard(
                title: '${user.name} ${user.surname}',
                subtitle: user.phone.isNotEmpty ? user.phone : null,
                trailing: l.pointsShort(user.points),
                icon: Icons.person_rounded,
                onTap: () {
                  context.read<UserProvider>().loginWithUser(user);
                  _enterHome(context);
                },
              ),
            );
          }),

          // Misafir girişi — her zaman listenin en sonunda
          FadeSlideIn(
            delay: Duration(milliseconds: 50 * members.length),
            child: _MemberCard(
              title: l.continueAsGuest,
              subtitle: null,
              trailing: null,
              icon: Icons.coffee_outlined,
              highlight: true,
              onTap: () {
                context.read<UserProvider>().loginAsGuest();
                _enterHome(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MemberCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? trailing;
  final IconData icon;
  final bool highlight;
  final VoidCallback onTap;

  const _MemberCard({
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.icon,
    required this.onTap,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: context.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        boxShadow: context.cardShadow,
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            gradient: highlight
                ? null
                : const LinearGradient(
                    colors: [AppColors.coffee, AppColors.espresso]),
            color: highlight
                ? AppColors.caramel.withValues(alpha: 0.25)
                : null,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon,
              color: highlight ? context.inkMedium : Colors.white, size: 22),
        ),
        title: Text(title,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: context.inkStrong)),
        subtitle: subtitle != null
            ? Text(subtitle!,
                style: const TextStyle(color: AppColors.muted, fontSize: 12))
            : null,
        trailing: trailing != null
            ? Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.caramel.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(trailing!,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: context.inkMedium,
                        fontSize: 13)),
              )
            : const Icon(Icons.chevron_right, color: AppColors.muted),
      ),
    );
  }
}
