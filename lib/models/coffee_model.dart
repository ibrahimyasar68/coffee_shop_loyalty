import 'package:hive/hive.dart';

part 'coffee_model.g.dart'; // Bu dosya otomatik üretilecek

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

  Coffee({
    required this.id,
    required this.category,
    required this.name,
    required this.price,
    required this.imagePath,
    required this.points,
    required this.note,
  });
}
