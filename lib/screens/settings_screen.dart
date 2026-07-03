import 'package:coffee_shop_loyalty/l10n/app_localizations.dart';
import 'package:coffee_shop_loyalty/providers/locale_provider.dart';
import 'package:coffee_shop_loyalty/providers/theme_provider.dart';
import 'package:coffee_shop_loyalty/screens/user_guide_screen.dart';
import 'package:coffee_shop_loyalty/theme/app_theme.dart';
import 'package:coffee_shop_loyalty/widgets/animations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final localeProvider = context.watch<LocaleProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final currentLang =
        (localeProvider.locale?.languageCode ?? 'tr').toUpperCase();

    return Scaffold(
      appBar: AppBar(title: Text(l.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ── DİL ──────────────────────────────────────────────
          _SectionTitle(icon: Icons.language, title: l.language),
          const SizedBox(height: 10),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'tr', label: Text('Türkçe')),
              ButtonSegment(value: 'en', label: Text('English')),
            ],
            selected: {currentLang == 'EN' ? 'en' : 'tr'},
            onSelectionChanged: (s) =>
                localeProvider.setLocale(Locale(s.first)),
          ),
          const SizedBox(height: 28),

          // ── TEMA ─────────────────────────────────────────────
          _SectionTitle(icon: Icons.brightness_6_outlined, title: l.theme),
          const SizedBox(height: 10),
          SegmentedButton<ThemeMode>(
            segments: [
              ButtonSegment(
                  value: ThemeMode.system,
                  label: Text(l.themeSystem),
                  icon: const Icon(Icons.settings_suggest_outlined)),
              ButtonSegment(
                  value: ThemeMode.light,
                  label: Text(l.themeLight),
                  icon: const Icon(Icons.light_mode_outlined)),
              ButtonSegment(
                  value: ThemeMode.dark,
                  label: Text(l.themeDark),
                  icon: const Icon(Icons.dark_mode_outlined)),
            ],
            selected: {themeProvider.mode},
            showSelectedIcon: false,
            onSelectionChanged: (s) => themeProvider.setMode(s.first),
          ),
          const SizedBox(height: 28),

          // ── KULLANMA KILAVUZU ────────────────────────────────
          _SectionTitle(icon: Icons.help_outline, title: l.userGuide),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(AppRadius.md),
              boxShadow: AppColors.cardShadow,
            ),
            child: ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md)),
              leading: const Icon(Icons.menu_book_rounded,
                  color: AppColors.mocha),
              title: Text(l.userGuide),
              trailing: const Icon(Icons.chevron_right, color: AppColors.muted),
              onTap: () => Navigator.push(
                context,
                fadeThroughRoute(const UserGuideScreen()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  const _SectionTitle({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.mocha),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.mocha,
          ),
        ),
      ],
    );
  }
}
