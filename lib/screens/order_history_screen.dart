import 'package:cached_network_image/cached_network_image.dart';
import 'package:coffee_shop_loyalty/models/order_model.dart';
import 'package:coffee_shop_loyalty/providers/order_provider.dart';
import 'package:coffee_shop_loyalty/l10n/app_localizations.dart';
import 'package:coffee_shop_loyalty/l10n/l10n_helpers.dart';
import 'package:coffee_shop_loyalty/providers/user_provider.dart';
import 'package:coffee_shop_loyalty/theme/app_theme.dart';
import 'package:coffee_shop_loyalty/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  String _formatDate(DateTime date, AppLocalizations l) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) return '${l.today}, ${_time(date)}';
    if (diff.inDays == 1) return '${l.yesterday}, ${_time(date)}';
    return '${date.day}.${date.month}.${date.year}  ${_time(date)}';
  }

  String _time(DateTime date) {
    final h = date.hour.toString().padLeft(2, '0');
    final m = date.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final userName = context.watch<UserProvider>().currentUser;
    final fullName =
        '${userName?.name ?? 'Misafir'} ${userName?.surname ?? ''}'.trim();
    final orders = context.watch<OrderProvider>().ordersForUser(fullName);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.espresso,
        title: Text(
          l.orderHistory,
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (orders.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined,
                  color: Colors.white70),
              tooltip: l.clearHistory,
              onPressed: () => _confirmClearAll(context),
            ),
        ],
      ),
      body: orders.isEmpty
          ? const _EmptyHistory()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return _OrderCard(
                  order: orders[index],
                  dateLabel: _formatDate(orders[index].date, l),
                  orderNumber: orders.length - index,
                );
              },
            ),
    );
  }

  void _confirmClearAll(BuildContext context) {
    final l = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l.clearHistory,
            style: TextStyle(color: context.inkStrong)),
        content: Text(l.clearHistoryConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l.cancel, style: const TextStyle(color: AppColors.muted)),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<OrderProvider>().clearAll();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l.clear, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// SİPARİŞ KARTI
// ══════════════════════════════════════════════════════════════
class _OrderCard extends StatefulWidget {
  final Order order;
  final String dateLabel;
  final int orderNumber;

  const _OrderCard({
    required this.order,
    required this.dateLabel,
    required this.orderNumber,
  });

  @override
  State<_OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<_OrderCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final order = widget.order;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: context.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.espresso.withValues(alpha: 0.07),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── BAŞLIK SATIRI ────────────────────────────────
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  // Sipariş ikonu
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.coffee, AppColors.espresso],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        '#${widget.orderNumber}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Tarih + ürün sayısı
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.dateLabel,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: context.inkStrong,
                              fontSize: 14),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          l.itemTypes(order.items.length),
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.muted),
                        ),
                      ],
                    ),
                  ),
                  // Tutar + puan
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        formatPrice(order.totalPrice),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: context.inkMedium,
                            fontSize: 15),
                      ),
                      const SizedBox(height: 3),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.caramel.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          l.pointsEarned(order.totalPoints),
                          style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.mocha,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(Icons.keyboard_arrow_down,
                        color: AppColors.muted),
                  ),
                ],
              ),
            ),
          ),

          // ── DETAY (AÇILIR) ────────────────────────────────
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: Column(
              children: [
                Divider(
                    color: context.softBorder,
                    height: 1,
                    indent: 14,
                    endIndent: 14),
                ...order.items.map((item) => _OrderItemRow(item: item)),
                // Toplam çizgisi
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Toplam',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: context.inkStrong)),
                      Text(
                        formatPrice(order.totalPrice),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: context.inkMedium,
                            fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// SİPARİŞ ÜRÜN SATIRI
// ══════════════════════════════════════════════════════════════
class _OrderItemRow extends StatelessWidget {
  final OrderItem item;

  const _OrderItemRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: item.imagePath,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(
                width: 40,
                height: 40,
                color: context.imagePlaceholder,
              ),
              errorWidget: (_, __, ___) => Container(
                width: 40,
                height: 40,
                color: AppColors.coffee,
                child:
                    const Icon(Icons.coffee, color: Colors.white54, size: 18),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    item.size == 'Orta'
                        ? item.coffeeName
                        : '${item.coffeeName} (${l.size(item.size)})',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: context.inkStrong,
                        fontSize: 13)),
                Text(l.quantityUnit(item.quantity),
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.muted)),
              ],
            ),
          ),
          Text(
            formatPrice((item.price * item.quantity)),
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: context.inkMedium,
                fontSize: 13),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// BOŞ GEÇMİŞ
// ══════════════════════════════════════════════════════════════
class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: AppColors.caramel.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.receipt_long_outlined,
                size: 44, color: AppColors.caramel),
          ),
          const SizedBox(height: 16),
          Text(
            l.noOrders,
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: context.inkStrong),
          ),
          const SizedBox(height: 8),
          Text(
            l.noOrdersHint,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}
