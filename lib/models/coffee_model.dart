import 'package:hive/hive.dart';

part 'coffee_model.g.dart'; // Bu dosya otomatik üretilecek

/// Uygulama genelinde geçerli sabit ürün kategorileri.
/// Serbest metin yerine bu liste kullanılarak "sıcak/Sıcak/sicak" gibi
/// büyük-küçük harf ve yazım farklarından doğan veri bölünmeleri önlenir.
/// (Mevcut tohum verisiyle uyum için küçük harf.)
const kProductCategories = ['sıcak', 'soğuk', 'tatlı'];

@HiveType(typeId: 1) // Her modelin benzersiz bir id'si olmalı
class Coffee extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String category;

  @HiveField(2)
  String name;

  @HiveField(3)
  double price;

  @HiveField(4)
  String imagePath;

  @HiveField(5)
  int points;

  @HiveField(6)
  String note;

  /// Boyut yalnızca sepete eklenen kopyalar için anlamlıdır
  /// (Küçük / Orta / Büyük). Katalog ürünleri varsayılan 'Orta' taşır.
  @HiveField(7)
  String size;

  Coffee({
    required this.id,
    required this.category,
    required this.name,
    required this.price,
    required this.imagePath,
    required this.points,
    required this.note,
    this.size = 'Orta',
  });
}
