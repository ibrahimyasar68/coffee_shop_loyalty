import 'dart:math';
import 'dart:ui';
import 'package:coffee_shop_loyalty/screens/add_user_screen.dart';
import 'package:coffee_shop_loyalty/l10n/app_localizations.dart';
import 'package:coffee_shop_loyalty/screens/member_select_screen.dart';
import 'package:coffee_shop_loyalty/theme/app_theme.dart';
import 'package:coffee_shop_loyalty/widgets/animations.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _entryController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  late AnimationController _steamController;
  final List<_SteamParticle> _particles = [];
  final Random _rng = Random();

  @override
  void initState() {
    super.initState();

    // Giriş animasyonu
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnim = CurvedAnimation(
      parent: _entryController,
      curve: const Interval(0.1, 1.0, curve: Curves.easeOut),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.10),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entryController,
      curve: const Interval(0.1, 1.0, curve: Curves.easeOut),
    ));

    // 16 buhar partikülleri — fincanın üzerinde yoğunlaşıyor
    for (int i = 0; i < 16; i++) {
      _particles.add(_SteamParticle(
        startX: 0.38 + _rng.nextDouble() * 0.24,
        startY: 0.48 + _rng.nextDouble() * 0.04,
        speed: 0.28 + _rng.nextDouble() * 0.28,
        size: 6.0 + _rng.nextDouble() * 10.0,
        phase: _rng.nextDouble(),
        drift: (_rng.nextDouble() - 0.5) * 0.08,
      ));
    }

    _steamController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();

    _entryController.forward();
  }

  @override
  void dispose() {
    _entryController.dispose();
    _steamController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.espressoNight,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── 1. TAM EKRAN GÖRSEL ──────────────────────────
          Image.asset(
            'assets/images/coffee.jpg',
            fit: BoxFit.cover,
            width: size.width,
            height: size.height,
            errorBuilder: (_, __, ___) => Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.mocha,
                    AppColors.espresso,
                    AppColors.espressoNight,
                  ],
                ),
              ),
              child: const Center(
                child: Icon(Icons.coffee, size: 80, color: Color(0x33D4A574)),
              ),
            ),
          ),

          // ── 2. GRADİENT OVERLAY ─────────────────────────
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x111A0A05),
                  Color(0x441A0A05),
                  Color(0xBB1A0A05),
                  AppColors.espressoNight,
                ],
                stops: [0.0, 0.30, 0.58, 1.0],
              ),
            ),
          ),

          // ── 3. BUHAR PARTİKÜLLERİ ───────────────────────
          AnimatedBuilder(
            animation: _steamController,
            builder: (context, _) => CustomPaint(
              size: size,
              painter: _SteamPainter(
                particles: _particles,
                progress: _steamController.value,
              ),
            ),
          ),

          // ── 4. BAŞLIK + CAM KART ─────────────────────────
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Üst başlık bölgesi
                    Padding(
                      padding: const EdgeInsets.fromLTRB(28, 36, 28, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Rozet
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.caramel
                                  .withValues(alpha: 0.13),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: AppColors.caramel
                                    .withValues(alpha: 0.35),
                                width: 0.7,
                              ),
                            ),
                            child: Text(
                              l.welcomeBrand,
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppColors.caramel,
                                letterSpacing: 3.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 22),

                          // Ana başlık
                          Text(
                            l.welcomeTitle,
                            style: const TextStyle(
                              fontSize: 52,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              height: 1.02,
                              letterSpacing: -1.5,
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Açıklama
                          Text(
                            l.welcomeSubtitle,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withValues(alpha: 0.50),
                              height: 1.65,
                              letterSpacing: 0.1,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    // ── KAHVE FİNCANI ────────────────────
                    Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF2A1208),
                          border: Border.all(
                            color:
                                AppColors.caramel.withValues(alpha: 0.55),
                            width: 1.8,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.caramel
                                  .withValues(alpha: 0.25),
                              blurRadius: 28,
                              spreadRadius: 6,
                            ),
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.40),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text('☕', style: TextStyle(fontSize: 44)),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ── CAM KART ────────────────────────────
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(22, 26, 22, 22),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.09),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.16),
                                width: 0.7,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Kart başlığı
                                Text(
                                  l.welcomeHeading,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white.withValues(alpha: 0.92),
                                    letterSpacing: -0.3,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  l.welcomeHint,
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    color: Colors.white.withValues(alpha: 0.40),
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 22),

                                // ÜYE GİRİŞİ — üye listesine götürür
                                // (misafir girişi de o listenin sonundadır)
                                _GlassButton(
                                  label: l.signIn,
                                  icon: Icons.person_outline_rounded,
                                  isPrimary: true,
                                  onTap: () => Navigator.pushReplacement(
                                    context,
                                    fadeThroughRoute(
                                        const MemberSelectScreen()),
                                  ),
                                ),
                                const SizedBox(height: 18),

                                // Alt link
                                Center(
                                  child: GestureDetector(
                                    onTap: () => Navigator.push(
                                      context,
                                      fadeThroughRoute(const AddUserScreen()),
                                    ),
                                    child: RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.white
                                              .withValues(alpha: 0.38),
                                        ),
                                        children: [
                                          TextSpan(text: l.noAccountPrefix),
                                          TextSpan(
                                            text: l.signUpArrow,
                                            style: const TextStyle(
                                              color: AppColors.caramel,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// CAM BUTON
// ══════════════════════════════════════════════════════════════
class _GlassButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool isPrimary;
  final VoidCallback onTap;

  const _GlassButton({
    required this.label,
    required this.icon,
    required this.isPrimary,
    required this.onTap,
  });

  @override
  State<_GlassButton> createState() => _GlassButtonState();
}

class _GlassButtonState extends State<_GlassButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            color: widget.isPrimary
                ? AppColors.caramel
                : Colors.white.withValues(alpha: _pressed ? 0.18 : 0.11),
            borderRadius: BorderRadius.circular(18),
            border: widget.isPrimary
                ? null
                : Border.all(
                    color: Colors.white.withValues(alpha: 0.22),
                    width: 0.7,
                  ),
            boxShadow: widget.isPrimary
                ? [
                    BoxShadow(
                      color: AppColors.caramel.withValues(alpha: 0.35),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.icon,
                  size: 19,
                  color: widget.isPrimary
                      ? AppColors.espressoNight
                      : Colors.white.withValues(alpha: 0.80),
                ),
                const SizedBox(width: 10),
                // Flexible: dar ekranlarda metin küçülüp gerekirse ... ile
                // kısalır; sabit Row taşmasını önler.
                Flexible(
                  child: Text(
                    widget.label,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: widget.isPrimary
                          ? AppColors.espressoNight
                          : Colors.white.withValues(alpha: 0.80),
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// BUHAR PARTİKÜLÜ MODELİ
// ══════════════════════════════════════════════════════════════
class _SteamParticle {
  final double startX;
  final double startY;
  final double speed;
  final double size;
  final double phase;
  final double drift;

  const _SteamParticle({
    required this.startX,
    required this.startY,
    required this.speed,
    required this.size,
    required this.phase,
    required this.drift,
  });
}

// ══════════════════════════════════════════════════════════════
// BUHAR PAINTER
// ══════════════════════════════════════════════════════════════
class _SteamPainter extends CustomPainter {
  final List<_SteamParticle> particles;
  final double progress;

  const _SteamPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final t = ((progress + p.phase) % 1.0);
      final life = (t / p.speed).clamp(0.0, 1.0);

      final x = (p.startX + p.drift * life) * size.width;
      final y = (p.startY - life * 0.22) * size.height;

      // Opaklık eğrisi: belir → doruk → söner
      double opacity;
      if (life < 0.15) {
        opacity = life / 0.15;
      } else if (life < 0.60) {
        opacity = 1.0;
      } else {
        opacity = 1.0 - (life - 0.60) / 0.40;
      }
      opacity *= 0.65; // belirgin buhar

      final radius = p.size * (0.5 + life * 1.2);

      final paint = Paint()
        ..color = Colors.white.withValues(alpha: opacity.clamp(0.0, 1.0))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(_SteamPainter old) => old.progress != progress;
}
