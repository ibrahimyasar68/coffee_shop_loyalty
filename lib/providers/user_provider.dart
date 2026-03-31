import 'package:coffee_shop_loyalty/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class UserProvider extends ChangeNotifier {
  Box<User> get _userBox => Hive.box<User>('user_box');

  UserProvider() {
    if (_userBox.isEmpty) {
      _userBox.put(
        'current_user',
        User(
          id: 00,
          name: 'Misafir',
          surname: 'Üye',
          phone: ' ',
          image: 'İmage<',
          points: 20,
          note: 'Genel Kullanıcı',
        ),
      );
      notifyListeners();
    }
  }

  User? get currentUser => _userBox.get('current_user');

  void addPoints(int amount) {
    final user = currentUser;
    if (user != null) {
      user.points += amount;
      user.save(); // Hive'a kaydeder
      notifyListeners(); // Ana sayfadaki puanı günceller
    }
  }

  Future<void> addUser(User user) async {
    final newCopy = User(
      id: user.id,
      name: user.name,
      surname: user.surname,
      phone: user.phone,
      image: user.image,
      points: user.points,
      note: user.note,
    );
    await _userBox.add(newCopy);
    notifyListeners();
  }

  Future<void> deleteUser(User user) async {
    await _userBox.delete(user);
    notifyListeners();
  }
}
