// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appName => 'Coffee Shop & Loyalty';

  @override
  String get appTitle => 'Coffee Shop';

  @override
  String get guest => 'Misafir';

  @override
  String get member => 'Üye';

  @override
  String get save => 'Kaydet';

  @override
  String get cancel => 'İptal';

  @override
  String get signIn => 'Giriş Yap';

  @override
  String get language => 'Dil';

  @override
  String get welcomeBrand => '☕   L O Y A L T Y';

  @override
  String get welcomeTitle => 'Kahve\nKokusu';

  @override
  String get welcomeSubtitle =>
      'Her yudumda puan kazan,\nhayalindeki kahveye ulaş.';

  @override
  String get welcomeHeading => 'Hoş Geldiniz';

  @override
  String get welcomeHint =>
      'Hesabınıza giriş yapın veya misafir olarak devam edin';

  @override
  String get continueAsGuest => 'Misafir Olarak Devam Et';

  @override
  String get noAccountPrefix => 'Hesabın yok mu?   ';

  @override
  String get signUpArrow => 'Üye Ol →';

  @override
  String get navHome => 'Ana Sayfa';

  @override
  String get navProfile => 'Profilim';

  @override
  String get navCart => 'Sepetim';

  @override
  String get searchHint => 'Kahve ara...';

  @override
  String get menu => 'Menü';

  @override
  String get noProducts => 'Ürün bulunamadı';

  @override
  String get addToCart => 'Sepete Ekle';

  @override
  String pointsShort(int points) {
    return '$points P';
  }

  @override
  String addedToCart(Object name, Object size) {
    return '$name ($size) sepete eklendi!';
  }

  @override
  String addedToCartQty(int quantity, Object name, Object size) {
    return '$quantity× $name ($size) sepete eklendi!';
  }

  @override
  String get sizeSmall => 'Küçük';

  @override
  String get sizeMedium => 'Orta';

  @override
  String get sizeLarge => 'Büyük';

  @override
  String get categoryHot => 'Sıcak';

  @override
  String get categoryCold => 'Soğuk';

  @override
  String get categoryDessert => 'Tatlı';

  @override
  String get cartTitle => 'Sepetim';

  @override
  String get cartEmpty => 'Sepetiniz boş ☕';

  @override
  String get totalAmount => 'Toplam Tutar';

  @override
  String get pointsToEarn => 'Kazanılacak Puan';

  @override
  String get completeOrder => 'Siparişi Tamamla';

  @override
  String get orderPlaced => '✅ Sipariş alındı, puanlar yüklendi!';

  @override
  String get orderSuccessTitle => 'Siparişin Alındı! 🎉';

  @override
  String get orderSuccessSubtitle => 'Hazırlanıyor, afiyet olsun ☕';

  @override
  String pointsEarnedMsg(int points) {
    return '+$points puan kazandın';
  }

  @override
  String get backToHome => 'Ana Sayfaya Dön';

  @override
  String get badgeMaster => 'Kahve Ustası ☕';

  @override
  String get badgeLover => 'Kahve Sever 🥇';

  @override
  String get badgeRegular => 'Düzenli Müşteri ⭐';

  @override
  String get badgeNew => 'Yeni Üye 🌱';

  @override
  String get totalPoints => 'Toplam Puanım';

  @override
  String get loyaltyTag => '☕ Loyalty';

  @override
  String pointsToNextLevel(int points) {
    return 'Sonraki seviye için $points puan kaldı';
  }

  @override
  String get maxLevel => 'En yüksek seviyedesiniz! 🏆';

  @override
  String get rewardGoal => 'Ödül Hedefi';

  @override
  String pointsToFreeCoffee(int points) {
    return 'Bedava kahveye $points puan';
  }

  @override
  String get freeCoffeeReady => 'Bedava kahve hakkın hazır! 🎉';

  @override
  String get accountInfo => 'Hesap Bilgileri';

  @override
  String get manageSection => 'Yönetim & Ayarlar';

  @override
  String get fullName => 'Ad Soyad';

  @override
  String get phone => 'Telefon';

  @override
  String get note => 'Not';

  @override
  String get notSpecified => 'Belirtilmemiş';

  @override
  String get noNote => 'Not yok';

  @override
  String get orderHistory => 'Sipariş Geçmişim';

  @override
  String get logout => 'Çıkış Yap';

  @override
  String get selectSize => 'Boyut Seçin';

  @override
  String get quantity => 'Adet';

  @override
  String get baseLabel => 'baz';

  @override
  String pointsValue(int points) {
    return '+$points puan';
  }

  @override
  String willEarnPoints(int points) {
    return '+$points puan kazanacaksınız';
  }

  @override
  String get clearHistory => 'Geçmişi Temizle';

  @override
  String get clearHistoryConfirm =>
      'Tüm sipariş geçmişi silinecek. Emin misiniz?';

  @override
  String get clear => 'Temizle';

  @override
  String get noOrders => 'Henüz siparişiniz yok';

  @override
  String get noOrdersHint =>
      'İlk siparişinizi verin ve\ngeçmişinizi burada görün ☕';

  @override
  String get today => 'Bugün';

  @override
  String get yesterday => 'Dün';

  @override
  String itemTypes(int count) {
    return '$count çeşit ürün';
  }

  @override
  String quantityUnit(int count) {
    return '$count adet';
  }

  @override
  String pointsEarned(int points) {
    return '+$points P';
  }

  @override
  String get newProduct => 'Yeni Ürün Ekle';

  @override
  String get productName => 'Ürün Adı';

  @override
  String get priceTl => 'Fiyat (TL)';

  @override
  String get points => 'Puan';

  @override
  String get category => 'Kategori';

  @override
  String get imageUrlOptional => 'Görsel URL (opsiyonel)';

  @override
  String get photoUrlOptional => 'Resim URL (opsiyonel)';

  @override
  String get noteOptional => 'Not (opsiyonel)';

  @override
  String get saveProduct => 'Ürünü Kaydet';

  @override
  String get requiredField => 'Zorunlu alan';

  @override
  String get enterValidNumber => 'Geçerli bir sayı girin';

  @override
  String get cannotBeNegative => 'Negatif olamaz';

  @override
  String get mustBePositive => '0\'dan büyük olmalı';

  @override
  String get productNameRequired => 'Ürün adı zorunlu';

  @override
  String get newUser => 'Yeni Kayıt Oluşturma';

  @override
  String get firstName => 'Adı';

  @override
  String get lastName => 'Soyadı';

  @override
  String fieldRequired(Object field) {
    return '$field zorunlu';
  }

  @override
  String get phoneRequired => 'Telefon zorunlu';

  @override
  String get phoneMinLength => 'Telefon en az 10 haneli olmalı';

  @override
  String get registerSuccess => 'Kayıt başarılı! Giriş yapabilirsiniz.';

  @override
  String get phoneAlreadyRegistered => 'Bu telefon numarası zaten kayıtlı!';

  @override
  String get selectMember => 'Üye Seçin';

  @override
  String get signUp => 'Üye Ol';

  @override
  String get tapMemberToLogin => 'Giriş yapmak için bir üyeye dokunun';

  @override
  String get adminCreatePin => 'Admin PIN Oluştur';

  @override
  String get adminLogin => 'Admin Girişi';

  @override
  String get pinSetupPrompt =>
      'Admin panelini korumak için 4 haneli bir PIN belirleyin.';

  @override
  String get pinEnterPrompt => 'Devam etmek için admin PIN\'inizi girin.';

  @override
  String get newPin => 'Yeni PIN';

  @override
  String get pin => 'PIN';

  @override
  String get pinRepeat => 'PIN (Tekrar)';

  @override
  String get createAndEnter => 'Oluştur ve Gir';

  @override
  String pinLengthError(int length) {
    return 'PIN $length haneli olmalı.';
  }

  @override
  String get pinMismatch => 'PIN ve onay eşleşmiyor.';

  @override
  String get pinWrong => 'Hatalı PIN.';

  @override
  String get forgotPin => 'PIN\'i mi unuttunuz?';

  @override
  String get resetPinTitle => 'PIN\'i Sıfırla';

  @override
  String get recoveryPrompt =>
      'Sıfırlamak için kurtarma kodunu girin. Bu kod işletme yöneticisindedir.';

  @override
  String get recoveryCode => 'Kurtarma Kodu';

  @override
  String get reset => 'Sıfırla';

  @override
  String get recoveryCodeWrong => 'Kurtarma kodu hatalı.';

  @override
  String get pinResetDone => 'PIN sıfırlandı. Yeni PIN belirleyin.';

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get userGuide => 'Kullanma Kılavuzu';

  @override
  String get theme => 'Tema';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get themeLight => 'Açık';

  @override
  String get themeDark => 'Koyu';

  @override
  String get guidePurposeTitle => 'Uygulamanın Amacı';

  @override
  String get guidePurposeBody =>
      'Coffee Shop & Loyalty, bir kahve dükkânının menüsünü sunan ve müşterilere her alışverişte puan kazandıran bir sadakat (loyalty) uygulamasıdır. Amaç, müşteri bağlılığını artırmak ve sipariş sürecini kolaylaştırmaktır.';

  @override
  String get guideUsageTitle => 'Ne İçin Kullanılır?';

  @override
  String get guideUsageBody =>
      'Müşteriler menüden ürün seçer, boyut belirler ve sepete ekler. Sipariş tamamlandığında kazandıkları puanlar hesaplarına işlenir. Kayıtlı üyeler puanlarını biriktirerek seviye atlar; misafirler ise hızlıca sipariş verebilir. İşletme yetkilisi ürün ve üyeleri yönetebilir.';

  @override
  String get guideFeaturesTitle => 'Özellikler ve Seçenekler';

  @override
  String get guideFeatureHome =>
      'Ana Sayfa: Menüyü görüntüleyin, kahve arayın, boyut seçip sepete ekleyin.';

  @override
  String get guideFeatureCart =>
      'Sepetim: Seçtiğiniz ürünleri görün, toplam tutarı ve kazanacağınız puanı kontrol edin, siparişi tamamlayın.';

  @override
  String get guideFeatureProfile =>
      'Profilim: Puanınızı, üyelik seviyenizi ve hesap bilgilerinizi görün.';

  @override
  String get guideFeatureOrders =>
      'Sipariş Geçmişim: Geçmiş siparişlerinizi tarih ve detaylarıyla inceleyin.';

  @override
  String get guideFeatureAdmin =>
      'Admin Paneli: PIN korumalı yönetim ekranı — ürün ve üye ekleme/düzenleme, istatistikler.';

  @override
  String get guideFeatureSettings =>
      'Ayarlar: Dil (TR/EN) ve tema (Sistem/Açık/Koyu) tercihlerini değiştirin.';

  @override
  String get adminPanel => 'Admin Paneli';

  @override
  String get changePin => 'PIN Değiştir';

  @override
  String get currentPin => 'Mevcut PIN';

  @override
  String get newPin4 => 'Yeni PIN (4 hane)';

  @override
  String get currentPinWrong => 'Mevcut PIN hatalı.';

  @override
  String get newPin4Error => 'Yeni PIN 4 haneli olmalı.';

  @override
  String get pinUpdated => 'PIN güncellendi.';

  @override
  String get tabSummary => 'Özet';

  @override
  String get tabProducts => 'Ürünler';

  @override
  String get tabMembers => 'Üyeler';

  @override
  String get statProducts => 'Ürün';

  @override
  String get statMembers => 'Üye';

  @override
  String get statMenuTotal => 'Menü Toplam';

  @override
  String get statPointsGiven => 'Dağıtılan Puan';

  @override
  String get loyalCustomers => '🏆 En Sadık Müşteriler';

  @override
  String get noMembersYet => 'Henüz üye yok';

  @override
  String get productsByCategory => '📊 Kategoriye Göre Ürünler';

  @override
  String get noProductsYet => 'Henüz ürün eklenmemiş';

  @override
  String get noRegisteredMembers => 'Henüz kayıtlı üye yok';

  @override
  String get deleteProduct => 'Ürünü Sil';

  @override
  String get deleteMember => 'Üyeyi Sil';

  @override
  String deleteConfirm(Object name) {
    return '$name silinecek. Emin misiniz?';
  }

  @override
  String get delete => 'Sil';

  @override
  String get phoneNone => 'Telefon yok';

  @override
  String get nameAndPriceRequired => 'Ürün adı ve fiyat zorunludur!';

  @override
  String get nameSurnameRequired => 'Ad ve soyad zorunludur!';

  @override
  String productAdded(Object name) {
    return '$name eklendi!';
  }

  @override
  String nameUpdated(Object name) {
    return '$name güncellendi!';
  }

  @override
  String get editProduct => 'Ürünü Düzenle';

  @override
  String get editMember => 'Üyeyi Düzenle';

  @override
  String get imageUrl => 'Görsel URL';

  @override
  String get photoUrl => 'Resim URL';

  @override
  String get update => 'Güncelle';

  @override
  String productCount(int count) {
    return '$count ürün';
  }
}
