import 'package:hive/hive.dart';

part 'user_model.g.dart'; // Bu dosya otomatik üretilecek

@HiveType(typeId: 0) // Her modelin benzersiz bir id'si olmalı
class User extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String surname;

  @HiveField(3)
  String phone;

  @HiveField(4)
  String image;

  @HiveField(5)
  int points;

  @HiveField(6)
  String note;

  User({
    required this.id,
    required this.name,
    required this.surname,
    required this.phone,
    required this.image,
    required this.points,
    required this.note,
  });
}
