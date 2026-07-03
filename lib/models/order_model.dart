import 'package:hive/hive.dart';

part 'order_model.g.dart';

@HiveType(typeId: 2)
class OrderItem extends HiveObject {
  @HiveField(0)
  String coffeeName;

  @HiveField(1)
  double price;

  @HiveField(2)
  int points;

  @HiveField(3)
  String imagePath;

  @HiveField(4)
  int quantity;

  @HiveField(5)
  String size;

  OrderItem({
    required this.coffeeName,
    required this.price,
    required this.points,
    required this.imagePath,
    required this.quantity,
    this.size = 'Orta',
  });
}

@HiveType(typeId: 3)
class Order extends HiveObject {
  @HiveField(0)
  DateTime date;

  @HiveField(1)
  List<OrderItem> items;

  @HiveField(2)
  double totalPrice;

  @HiveField(3)
  int totalPoints;

  @HiveField(4)
  String userName;

  Order({
    required this.date,
    required this.items,
    required this.totalPrice,
    required this.totalPoints,
    required this.userName,
  });
}
