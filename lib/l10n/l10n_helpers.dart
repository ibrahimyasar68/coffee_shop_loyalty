import 'package:coffee_shop_loyalty/l10n/app_localizations.dart';

/// Hive'da kanonik (Türkçe) olarak saklanan boyut ve kategori değerlerini
/// görüntü için aktif dile çevirir. Depolanan değer değişmez; yalnızca
/// gösterim yerelleştirilir.
extension L10nDomain on AppLocalizations {
  String size(String canonical) {
    switch (canonical) {
      case 'Küçük':
        return sizeSmall;
      case 'Büyük':
        return sizeLarge;
      default:
        return sizeMedium; // 'Orta'
    }
  }

  String categoryLabel(String canonical) {
    switch (canonical.toLowerCase().trim()) {
      case 'sıcak':
      case 'sicak':
        return categoryHot;
      case 'soğuk':
      case 'soguk':
        return categoryCold;
      case 'tatlı':
      case 'tatli':
        return categoryDessert;
      default:
        return canonical;
    }
  }
}
