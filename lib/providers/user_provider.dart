import 'package:coffee_shop_loyalty/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class UserProvider extends ChangeNotifier {
  // Aktif giriş yapmış kullanıcıyı bellekte tutuyoruz
  User? _loggedInUser;

  Box<User>? get _userBox {
    if (Hive.isBoxOpen('user_box')) {
      return Hive.box<User>('user_box');
    }
    return null;
  }

  UserProvider() {
    Future.delayed(Duration.zero, () => _initUser());
  }

  void _initUser() {
    final box = _userBox;
    if (box == null) {
      debugPrint("UserProvider: user_box henüz açılmadı!");
      return;
    }
    // Varsayılan misafir kullanıcıyı oluştur (sadece ilk açılışta)
    if (box.get('misafir') == null) {
      box.put(
        'misafir',
        User(
          id: 0,
          name: 'Misafir',
          surname: 'Üye',
          phone: '',
          image: '',
          points: 0,
          note: 'Genel Kullanıcı',
        ),
      );
    }
    notifyListeners();
  }

  // Giriş yapmış kullanıcı — yoksa misafir döner
  User? get currentUser {
    if (_loggedInUser != null) return _loggedInUser;
    return _userBox?.get('misafir');
  }

  // Misafir girişi
  void loginAsGuest() {
    _loggedInUser = null;
    notifyListeners();
  }

  // Belirli bir üyeyle doğrudan giriş (üye listesinden seçildiğinde)
  void loginWithUser(User user) {
    _loggedInUser = user;
    notifyListeners();
  }

  // Kayıtlı üyeler — kalıcı/ortak 'misafir' hesabı hariç
  List<User> get registeredUsers =>
      _userBox?.values.where((u) => u.key != 'misafir').toList() ?? [];

  // Puan ekleme — yalnızca giriş yapmış kayıtlı üyeler puan kazanır.
  // Misafir hesabı (ortak ve kalıcı) puan biriktirmez.
  void addPoints(int amount) {
    final user = _loggedInUser;
    if (user != null) {
      user.points += amount;
      user.save();
      notifyListeners();
    }
  }

  // Yeni kullanıcı kaydı — telefon numarası key olarak kullanılıyor
  Future<bool> addUser(User user) async {
    final box = _userBox;
    if (box == null) return false;

    // Aynı telefon numarasıyla kayıt var mı kontrol et
    if (box.get(user.phone) != null) {
      return false; // Zaten kayıtlı
    }

    final newUser = User(
      id: user.id,
      name: user.name,
      surname: user.surname,
      phone: user.phone,
      image: user.image,
      points: user.points,
      note: user.note,
    );
    await box.put(user.phone, newUser);
    notifyListeners();
    return true;
  }

  Future<void> deleteUser(User user) async {
    await _userBox?.delete(user.phone);
    notifyListeners();
  }

  // Üye güncelleme
  // Not: Kayıtlı üyeler telefon numarası "key" olarak saklandığından,
  // telefon değişirse Hive kaydını yeni key altına taşımak gerekir.
  // Aksi halde key ile saklanan veri ayrışır ve deleteUser çalışmaz.
  Future<void> updateUser(
    User user, {
    required String name,
    required String surname,
    required String phone,
    required String image,
    required int points,
    required String note,
  }) async {
    final box = _userBox;
    final oldKey = user.key; // mevcut Hive key'i (genellikle eski telefon)

    user.name = name;
    user.surname = surname;
    user.phone = phone;
    user.image = image;
    user.points = points;
    user.note = note;

    // Telefon (= key) değiştiyse ve bu misafir hesabı değilse kaydı yeniden anahtarla
    if (box != null &&
        oldKey is String &&
        oldKey != 'misafir' &&
        oldKey != phone) {
      await box.delete(oldKey);
      await box.put(phone, user);
    } else {
      await user.save();
    }
    notifyListeners();
  }

  List<User> get allUsers => _userBox?.values.toList() ?? [];
}
