import 'package:flutter/material.dart';

/// Varsayılan platform geçişi yerine yumuşak bir "fade-through" geçişi:
/// yeni sayfa hafif büyüyerek belirir, eski sayfa solar. Tüm ekran
/// geçişlerinde [MaterialPageRoute] yerine kullanılır.
Route<T> fadeThroughRoute<T>(Widget page) {
  return PageRouteBuilder<T>(
    transitionDuration: const Duration(milliseconds: 360),
    reverseTransitionDuration: const Duration(milliseconds: 280),
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, animation, __, child) {
      final curved =
          CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: curved,
        child: Transform.scale(
          // 0.96'dan 1.0'a hafif yakınlaşma
          scale: 0.96 + 0.04 * curved.value,
          child: child,
        ),
      );
    },
  );
}

/// Çocuğu monte edilirken aşağıdan yukarı kayma + solma ile gösterir.
/// Liste öğelerinde [delay]'i indekse göre vererek kademeli (staggered)
/// bir açılış elde edilir: `FadeSlideIn(delay: Duration(milliseconds: 60 * i))`.
class FadeSlideIn extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final double offsetY;

  const FadeSlideIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 420),
    this.offsetY = 24,
  });

  @override
  State<FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<FadeSlideIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: widget.duration);
  late final Animation<double> _curve =
      CurvedAnimation(parent: _c, curve: Curves.easeOutCubic);

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      if (mounted) _c.forward();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _curve,
      builder: (context, child) => Opacity(
        opacity: _curve.value,
        child: Transform.translate(
          offset: Offset(0, (1 - _curve.value) * widget.offsetY),
          child: child,
        ),
      ),
      child: widget.child,
    );
  }
}

/// Dokunulduğunda hafifçe küçülüp bırakılınca geri yaylanan sarmalayıcı.
/// Butonlara fiziksel bir "basıldı" hissi katar.
class ScaleTap extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final double scale;

  const ScaleTap({
    super.key,
    required this.child,
    required this.onTap,
    this.scale = 0.94,
  });

  @override
  State<ScaleTap> createState() => _ScaleTapState();
}

class _ScaleTapState extends State<ScaleTap> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _down = true),
      onTapCancel: () => setState(() => _down = false),
      onTapUp: (_) => setState(() => _down = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _down ? widget.scale : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

/// Sayısal değer değişimini yumuşakça canlandırarak gösterir
/// (ör. puanın 0'dan hedefe sayması). [builder] biçimlendirmeyi yönetir.
class AnimatedCount extends StatelessWidget {
  final int value;
  final Duration duration;
  final Widget Function(BuildContext context, int value) builder;

  const AnimatedCount({
    super.key,
    required this.value,
    required this.builder,
    this.duration = const Duration(milliseconds: 900),
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: value),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, v, _) => builder(context, v),
    );
  }
}
