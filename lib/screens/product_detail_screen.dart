import 'package:cached_network_image/cached_network_image.dart';
import 'package:coffee_shop_loyalty/models/coffee_model.dart';
import 'package:coffee_shop_loyalty/l10n/app_localizations.dart';
import 'package:coffee_shop_loyalty/l10n/l10n_helpers.dart';
import 'package:coffee_shop_loyalty/providers/cart_provider.dart';
import 'package:coffee_shop_loyalty/theme/app_theme.dart';
import 'package:coffee_shop_loyalty/utils/format.dart';
import 'package:coffee_shop_loyalty/widgets/animations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final Coffee coffee;
  const ProductDetailScreen({super.key, required this.coffee});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  int _quantity = 1;
  String _selectedSize = 'Orta';

  // Boyut çarpanları: Orta = baz fiyat, Küçük = -%10, Büyük = +%10
  final List<String> _sizeLabels = ['Küçük', 'Orta', 'Büyük'];

  double _sizeMultiplier(String size) {
    switch (size) {
      case 'Küçük':
        return 0.90;
      case 'Büyük':
        return 1.10;
      default:
        return 1.00;
    }
  }

  double get _sizePrice => widget.coffee.price * _sizeMultiplier(_selectedSize);

  int get _sizePoints =>
      (widget.coffee.points * _sizeMultiplier(_selectedSize)).round();

  double get _totalPrice => _sizePrice * _quantity;
  int get _totalPoints => _sizePoints * _quantity;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  String _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'sıcak':
        return '☕';
      case 'soğuk':
        return '🧊';
      case 'tatlı':
        return '🍰';
      default:
        return '☕';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final coffee = widget.coffee;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: CustomScrollView(
        slivers: [
          // ── HERO GÖRSEL ─────────────────────────────────────
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: AppColors.espresso,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Ürün görseli
                  CachedNetworkImage(
                    imageUrl: coffee.imagePath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    placeholder: (_, __) =>
                        Container(color: AppColors.coffee),
                    errorWidget: (_, __, ___) => Container(
                      color: AppColors.coffee,
                      child: const Icon(Icons.coffee,
                          size: 80, color: Colors.white30),
                    ),
                  ),
                  // Gradient overlay
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.transparent,
                          Color(0xCC3B1F0E),
                        ],
                        stops: [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                  // Kategori badge
                  Positioned(
                    bottom: 20,
                    left: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.caramel.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${_getCategoryIcon(coffee.category)}  ${l.categoryLabel(coffee.category).toUpperCase()}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.espresso,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── DETAY İÇERİK ────────────────────────────────────
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // İsim + Fiyat
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              coffee.name,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppColors.espresso,
                                height: 1.1,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                formatPrice(_sizePrice),
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.coffee,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.caramel
                                      .withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  l.pointsValue(_sizePoints),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.mocha,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // Not / Açıklama
                      if (coffee.note.trim().isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text(
                          coffee.note,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.muted,
                            height: 1.5,
                          ),
                        ),
                      ],

                      const SizedBox(height: 24),
                      const Divider(color: Color(0xFFE5DDD5)),
                      const SizedBox(height: 20),

                      // BOYUT SEÇİMİ
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l.selectSize,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.espresso,
                            ),
                          ),
                          Text(
                            '${formatPrice(_sizePrice)} · ${_sizePoints}p',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.mocha,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: _sizeLabels.map((sizeLabel) {
                          final isSelected = _selectedSize == sizeLabel;
                          final price =
                              (coffee.price * _sizeMultiplier(sizeLabel));
                          final pts =
                              (coffee.points * _sizeMultiplier(sizeLabel))
                                  .round();
                          // Fiyat farkı etiketi
                          String diffLabel;
                          if (sizeLabel == 'Küçük') {
                            diffLabel = '-%10';
                          } else if (sizeLabel == 'Büyük') {
                            diffLabel = '+%10';
                          } else {
                            diffLabel = l.baseLabel;
                          }

                          return Expanded(
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedSize = sizeLabel),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.espresso
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.espresso
                                        : const Color(0xFFE5DDD5),
                                  ),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: AppColors.espresso
                                                .withValues(alpha: 0.3),
                                            blurRadius: 8,
                                            offset: const Offset(0, 3),
                                          )
                                        ]
                                      : [],
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      l.size(sizeLabel),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: isSelected
                                            ? Colors.white
                                            : AppColors.espresso,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      formatPrice(price),
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: isSelected
                                            ? AppColors.caramel
                                            : AppColors.coffee,
                                      ),
                                    ),
                                    Text(
                                      '$diffLabel · ${pts}p',
                                      style: TextStyle(
                                        fontSize: 9,
                                        color: isSelected
                                            ? Colors.white54
                                            : AppColors.muted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 24),

                      // ADET SEÇİMİ
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l.quantity,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.espresso,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.espresso
                                      .withValues(alpha: 0.08),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                _QtyButton(
                                  icon: Icons.remove,
                                  onTap: () {
                                    if (_quantity > 1) {
                                      setState(() => _quantity--);
                                    }
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Text(
                                    '$_quantity',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.espresso,
                                    ),
                                  ),
                                ),
                                _QtyButton(
                                  icon: Icons.add,
                                  onTap: () => setState(() => _quantity++),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // ÖZET SATIRI
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0E6DA),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l.totalAmount,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.muted,
                                  ),
                                ),
                                Text(
                                  formatPrice(_totalPrice),
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.espresso,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.caramel
                                    .withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                l.willEarnPoints(_totalPoints),
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.coffee,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // SEPETE EKLE BUTONU
                      ScaleTap(
                        onTap: () {
                          final cart = context.read<CartProvider>();
                          for (int i = 0; i < _quantity; i++) {
                            cart.addToCartWithSize(coffee, _selectedSize);
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  l.addedToCartQty(_quantity, coffee.name,
                                      l.size(_selectedSize))),
                              backgroundColor: AppColors.espresso,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: AppColors.ctaGradient,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    AppColors.espresso.withValues(alpha: 0.4),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.shopping_cart_outlined,
                                  color: Colors.white),
                              const SizedBox(width: 8),
                              Text(
                                l.addToCart,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── ADET BUTONU ───────────────────────────────────────────────
class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.cream,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 18, color: AppColors.espresso),
      ),
    );
  }
}
