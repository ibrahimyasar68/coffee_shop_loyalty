import 'package:intl/intl.dart';

/// Fiyatları ₺ simgesi ve Türkçe binlik ayracıyla biçimlendirir.
/// Örn: 1250 → "₺1.250", 85.5 → "₺86" (kuruşsuz, yuvarlanmış).
final _priceFormat = NumberFormat('#,##0', 'tr_TR');

String formatPrice(num value) => '₺${_priceFormat.format(value.round())}';
