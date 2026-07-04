import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr')
  ];

  /// No description provided for @appName.
  ///
  /// In tr, this message translates to:
  /// **'Coffee Shop & Loyalty'**
  String get appName;

  /// No description provided for @appTitle.
  ///
  /// In tr, this message translates to:
  /// **'Coffee Shop'**
  String get appTitle;

  /// No description provided for @guest.
  ///
  /// In tr, this message translates to:
  /// **'Misafir'**
  String get guest;

  /// No description provided for @member.
  ///
  /// In tr, this message translates to:
  /// **'Üye'**
  String get member;

  /// No description provided for @save.
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In tr, this message translates to:
  /// **'İptal'**
  String get cancel;

  /// No description provided for @signIn.
  ///
  /// In tr, this message translates to:
  /// **'Giriş Yap'**
  String get signIn;

  /// No description provided for @language.
  ///
  /// In tr, this message translates to:
  /// **'Dil'**
  String get language;

  /// No description provided for @welcomeBrand.
  ///
  /// In tr, this message translates to:
  /// **'☕   L O Y A L T Y'**
  String get welcomeBrand;

  /// No description provided for @welcomeTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kahve\nKokusu'**
  String get welcomeTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Her yudumda puan kazan,\nhayalindeki kahveye ulaş.'**
  String get welcomeSubtitle;

  /// No description provided for @welcomeHeading.
  ///
  /// In tr, this message translates to:
  /// **'Hoş Geldiniz'**
  String get welcomeHeading;

  /// No description provided for @welcomeHint.
  ///
  /// In tr, this message translates to:
  /// **'Hesabınıza giriş yapın veya misafir olarak devam edin'**
  String get welcomeHint;

  /// No description provided for @continueAsGuest.
  ///
  /// In tr, this message translates to:
  /// **'Misafir Olarak Devam Et'**
  String get continueAsGuest;

  /// No description provided for @noAccountPrefix.
  ///
  /// In tr, this message translates to:
  /// **'Hesabın yok mu?   '**
  String get noAccountPrefix;

  /// No description provided for @signUpArrow.
  ///
  /// In tr, this message translates to:
  /// **'Üye Ol →'**
  String get signUpArrow;

  /// No description provided for @navHome.
  ///
  /// In tr, this message translates to:
  /// **'Ana Sayfa'**
  String get navHome;

  /// No description provided for @navProfile.
  ///
  /// In tr, this message translates to:
  /// **'Profilim'**
  String get navProfile;

  /// No description provided for @navCart.
  ///
  /// In tr, this message translates to:
  /// **'Sepetim'**
  String get navCart;

  /// No description provided for @searchHint.
  ///
  /// In tr, this message translates to:
  /// **'Kahve ara...'**
  String get searchHint;

  /// No description provided for @menu.
  ///
  /// In tr, this message translates to:
  /// **'Menü'**
  String get menu;

  /// No description provided for @noProducts.
  ///
  /// In tr, this message translates to:
  /// **'Ürün bulunamadı'**
  String get noProducts;

  /// No description provided for @addToCart.
  ///
  /// In tr, this message translates to:
  /// **'Sepete Ekle'**
  String get addToCart;

  /// No description provided for @pointsShort.
  ///
  /// In tr, this message translates to:
  /// **'{points} P'**
  String pointsShort(int points);

  /// No description provided for @addedToCart.
  ///
  /// In tr, this message translates to:
  /// **'{name} ({size}) sepete eklendi!'**
  String addedToCart(Object name, Object size);

  /// No description provided for @addedToCartQty.
  ///
  /// In tr, this message translates to:
  /// **'{quantity}× {name} ({size}) sepete eklendi!'**
  String addedToCartQty(int quantity, Object name, Object size);

  /// No description provided for @sizeSmall.
  ///
  /// In tr, this message translates to:
  /// **'Küçük'**
  String get sizeSmall;

  /// No description provided for @sizeMedium.
  ///
  /// In tr, this message translates to:
  /// **'Orta'**
  String get sizeMedium;

  /// No description provided for @sizeLarge.
  ///
  /// In tr, this message translates to:
  /// **'Büyük'**
  String get sizeLarge;

  /// No description provided for @categoryHot.
  ///
  /// In tr, this message translates to:
  /// **'Sıcak'**
  String get categoryHot;

  /// No description provided for @categoryCold.
  ///
  /// In tr, this message translates to:
  /// **'Soğuk'**
  String get categoryCold;

  /// No description provided for @categoryDessert.
  ///
  /// In tr, this message translates to:
  /// **'Tatlı'**
  String get categoryDessert;

  /// No description provided for @cartTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sepetim'**
  String get cartTitle;

  /// No description provided for @cartEmpty.
  ///
  /// In tr, this message translates to:
  /// **'Sepetiniz boş ☕'**
  String get cartEmpty;

  /// No description provided for @totalAmount.
  ///
  /// In tr, this message translates to:
  /// **'Toplam Tutar'**
  String get totalAmount;

  /// No description provided for @pointsToEarn.
  ///
  /// In tr, this message translates to:
  /// **'Kazanılacak Puan'**
  String get pointsToEarn;

  /// No description provided for @completeOrder.
  ///
  /// In tr, this message translates to:
  /// **'Siparişi Tamamla'**
  String get completeOrder;

  /// No description provided for @orderPlaced.
  ///
  /// In tr, this message translates to:
  /// **'✅ Sipariş alındı, puanlar yüklendi!'**
  String get orderPlaced;

  /// No description provided for @orderSuccessTitle.
  ///
  /// In tr, this message translates to:
  /// **'Siparişin Alındı! 🎉'**
  String get orderSuccessTitle;

  /// No description provided for @orderSuccessSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Hazırlanıyor, afiyet olsun ☕'**
  String get orderSuccessSubtitle;

  /// No description provided for @pointsEarnedMsg.
  ///
  /// In tr, this message translates to:
  /// **'+{points} puan kazandın'**
  String pointsEarnedMsg(int points);

  /// No description provided for @backToHome.
  ///
  /// In tr, this message translates to:
  /// **'Ana Sayfaya Dön'**
  String get backToHome;

  /// No description provided for @badgeMaster.
  ///
  /// In tr, this message translates to:
  /// **'Kahve Ustası ☕'**
  String get badgeMaster;

  /// No description provided for @badgeLover.
  ///
  /// In tr, this message translates to:
  /// **'Kahve Sever 🥇'**
  String get badgeLover;

  /// No description provided for @badgeRegular.
  ///
  /// In tr, this message translates to:
  /// **'Düzenli Müşteri ⭐'**
  String get badgeRegular;

  /// No description provided for @badgeNew.
  ///
  /// In tr, this message translates to:
  /// **'Yeni Üye 🌱'**
  String get badgeNew;

  /// No description provided for @totalPoints.
  ///
  /// In tr, this message translates to:
  /// **'Toplam Puanım'**
  String get totalPoints;

  /// No description provided for @loyaltyTag.
  ///
  /// In tr, this message translates to:
  /// **'☕ Loyalty'**
  String get loyaltyTag;

  /// No description provided for @pointsToNextLevel.
  ///
  /// In tr, this message translates to:
  /// **'Sonraki seviye için {points} puan kaldı'**
  String pointsToNextLevel(int points);

  /// No description provided for @maxLevel.
  ///
  /// In tr, this message translates to:
  /// **'En yüksek seviyedesiniz! 🏆'**
  String get maxLevel;

  /// No description provided for @rewardGoal.
  ///
  /// In tr, this message translates to:
  /// **'Ödül Hedefi'**
  String get rewardGoal;

  /// No description provided for @pointsToFreeCoffee.
  ///
  /// In tr, this message translates to:
  /// **'Bedava kahveye {points} puan'**
  String pointsToFreeCoffee(int points);

  /// No description provided for @freeCoffeeReady.
  ///
  /// In tr, this message translates to:
  /// **'Bedava kahve hakkın hazır! 🎉'**
  String get freeCoffeeReady;

  /// No description provided for @redeemReward.
  ///
  /// In tr, this message translates to:
  /// **'Ödülü Kullan'**
  String get redeemReward;

  /// No description provided for @redeemConfirmMessage.
  ///
  /// In tr, this message translates to:
  /// **'100 puan karşılığında 1 bedava kahve kullanılacak. Onaylıyor musun?'**
  String get redeemConfirmMessage;

  /// No description provided for @rewardRedeemed.
  ///
  /// In tr, this message translates to:
  /// **'Afiyet olsun! Bedava kahven kullanıldı. ☕'**
  String get rewardRedeemed;

  /// No description provided for @freeCoffeeItem.
  ///
  /// In tr, this message translates to:
  /// **'🎁 Bedava Kahve (Ödül)'**
  String get freeCoffeeItem;

  /// No description provided for @accountInfo.
  ///
  /// In tr, this message translates to:
  /// **'Hesap Bilgileri'**
  String get accountInfo;

  /// No description provided for @manageSection.
  ///
  /// In tr, this message translates to:
  /// **'Yönetim & Ayarlar'**
  String get manageSection;

  /// No description provided for @fullName.
  ///
  /// In tr, this message translates to:
  /// **'Ad Soyad'**
  String get fullName;

  /// No description provided for @phone.
  ///
  /// In tr, this message translates to:
  /// **'Telefon'**
  String get phone;

  /// No description provided for @note.
  ///
  /// In tr, this message translates to:
  /// **'Not'**
  String get note;

  /// No description provided for @notSpecified.
  ///
  /// In tr, this message translates to:
  /// **'Belirtilmemiş'**
  String get notSpecified;

  /// No description provided for @noNote.
  ///
  /// In tr, this message translates to:
  /// **'Not yok'**
  String get noNote;

  /// No description provided for @orderHistory.
  ///
  /// In tr, this message translates to:
  /// **'Sipariş Geçmişim'**
  String get orderHistory;

  /// No description provided for @logout.
  ///
  /// In tr, this message translates to:
  /// **'Çıkış Yap'**
  String get logout;

  /// No description provided for @logoutConfirmMessage.
  ///
  /// In tr, this message translates to:
  /// **'Oturum kapatılacak ve giriş ekranına dönülecek. Emin misin?'**
  String get logoutConfirmMessage;

  /// No description provided for @selectSize.
  ///
  /// In tr, this message translates to:
  /// **'Boyut Seçin'**
  String get selectSize;

  /// No description provided for @quantity.
  ///
  /// In tr, this message translates to:
  /// **'Adet'**
  String get quantity;

  /// No description provided for @baseLabel.
  ///
  /// In tr, this message translates to:
  /// **'baz'**
  String get baseLabel;

  /// No description provided for @pointsValue.
  ///
  /// In tr, this message translates to:
  /// **'+{points} puan'**
  String pointsValue(int points);

  /// No description provided for @willEarnPoints.
  ///
  /// In tr, this message translates to:
  /// **'+{points} puan kazanacaksınız'**
  String willEarnPoints(int points);

  /// No description provided for @clearHistory.
  ///
  /// In tr, this message translates to:
  /// **'Geçmişi Temizle'**
  String get clearHistory;

  /// No description provided for @clearHistoryConfirm.
  ///
  /// In tr, this message translates to:
  /// **'Tüm sipariş geçmişi silinecek. Emin misiniz?'**
  String get clearHistoryConfirm;

  /// No description provided for @clear.
  ///
  /// In tr, this message translates to:
  /// **'Temizle'**
  String get clear;

  /// No description provided for @noOrders.
  ///
  /// In tr, this message translates to:
  /// **'Henüz siparişiniz yok'**
  String get noOrders;

  /// No description provided for @noOrdersHint.
  ///
  /// In tr, this message translates to:
  /// **'İlk siparişinizi verin ve\ngeçmişinizi burada görün ☕'**
  String get noOrdersHint;

  /// No description provided for @today.
  ///
  /// In tr, this message translates to:
  /// **'Bugün'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In tr, this message translates to:
  /// **'Dün'**
  String get yesterday;

  /// No description provided for @itemTypes.
  ///
  /// In tr, this message translates to:
  /// **'{count} çeşit ürün'**
  String itemTypes(int count);

  /// No description provided for @quantityUnit.
  ///
  /// In tr, this message translates to:
  /// **'{count} adet'**
  String quantityUnit(int count);

  /// No description provided for @pointsEarned.
  ///
  /// In tr, this message translates to:
  /// **'+{points} P'**
  String pointsEarned(int points);

  /// No description provided for @newProduct.
  ///
  /// In tr, this message translates to:
  /// **'Yeni Ürün Ekle'**
  String get newProduct;

  /// No description provided for @productName.
  ///
  /// In tr, this message translates to:
  /// **'Ürün Adı'**
  String get productName;

  /// No description provided for @priceTl.
  ///
  /// In tr, this message translates to:
  /// **'Fiyat (TL)'**
  String get priceTl;

  /// No description provided for @points.
  ///
  /// In tr, this message translates to:
  /// **'Puan'**
  String get points;

  /// No description provided for @category.
  ///
  /// In tr, this message translates to:
  /// **'Kategori'**
  String get category;

  /// No description provided for @imageUrlOptional.
  ///
  /// In tr, this message translates to:
  /// **'Görsel URL (opsiyonel)'**
  String get imageUrlOptional;

  /// No description provided for @photoUrlOptional.
  ///
  /// In tr, this message translates to:
  /// **'Resim URL (opsiyonel)'**
  String get photoUrlOptional;

  /// No description provided for @noteOptional.
  ///
  /// In tr, this message translates to:
  /// **'Not (opsiyonel)'**
  String get noteOptional;

  /// No description provided for @saveProduct.
  ///
  /// In tr, this message translates to:
  /// **'Ürünü Kaydet'**
  String get saveProduct;

  /// No description provided for @requiredField.
  ///
  /// In tr, this message translates to:
  /// **'Zorunlu alan'**
  String get requiredField;

  /// No description provided for @enterValidNumber.
  ///
  /// In tr, this message translates to:
  /// **'Geçerli bir sayı girin'**
  String get enterValidNumber;

  /// No description provided for @cannotBeNegative.
  ///
  /// In tr, this message translates to:
  /// **'Negatif olamaz'**
  String get cannotBeNegative;

  /// No description provided for @mustBePositive.
  ///
  /// In tr, this message translates to:
  /// **'0\'dan büyük olmalı'**
  String get mustBePositive;

  /// No description provided for @productNameRequired.
  ///
  /// In tr, this message translates to:
  /// **'Ürün adı zorunlu'**
  String get productNameRequired;

  /// No description provided for @newUser.
  ///
  /// In tr, this message translates to:
  /// **'Yeni Kayıt Oluşturma'**
  String get newUser;

  /// No description provided for @firstName.
  ///
  /// In tr, this message translates to:
  /// **'Adı'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In tr, this message translates to:
  /// **'Soyadı'**
  String get lastName;

  /// No description provided for @fieldRequired.
  ///
  /// In tr, this message translates to:
  /// **'{field} zorunlu'**
  String fieldRequired(Object field);

  /// No description provided for @phoneRequired.
  ///
  /// In tr, this message translates to:
  /// **'Telefon zorunlu'**
  String get phoneRequired;

  /// No description provided for @phoneMinLength.
  ///
  /// In tr, this message translates to:
  /// **'Telefon en az 10 haneli olmalı'**
  String get phoneMinLength;

  /// No description provided for @registerSuccess.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt başarılı! Giriş yapabilirsiniz.'**
  String get registerSuccess;

  /// No description provided for @phoneAlreadyRegistered.
  ///
  /// In tr, this message translates to:
  /// **'Bu telefon numarası zaten kayıtlı!'**
  String get phoneAlreadyRegistered;

  /// No description provided for @selectMember.
  ///
  /// In tr, this message translates to:
  /// **'Üye Seçin'**
  String get selectMember;

  /// No description provided for @signUp.
  ///
  /// In tr, this message translates to:
  /// **'Üye Ol'**
  String get signUp;

  /// No description provided for @tapMemberToLogin.
  ///
  /// In tr, this message translates to:
  /// **'Giriş yapmak için bir üyeye dokunun'**
  String get tapMemberToLogin;

  /// No description provided for @adminCreatePin.
  ///
  /// In tr, this message translates to:
  /// **'Admin PIN Oluştur'**
  String get adminCreatePin;

  /// No description provided for @adminLogin.
  ///
  /// In tr, this message translates to:
  /// **'Admin Girişi'**
  String get adminLogin;

  /// No description provided for @pinSetupPrompt.
  ///
  /// In tr, this message translates to:
  /// **'Admin panelini korumak için 4 haneli bir PIN belirleyin.'**
  String get pinSetupPrompt;

  /// No description provided for @pinEnterPrompt.
  ///
  /// In tr, this message translates to:
  /// **'Devam etmek için admin PIN\'inizi girin.'**
  String get pinEnterPrompt;

  /// No description provided for @newPin.
  ///
  /// In tr, this message translates to:
  /// **'Yeni PIN'**
  String get newPin;

  /// No description provided for @pin.
  ///
  /// In tr, this message translates to:
  /// **'PIN'**
  String get pin;

  /// No description provided for @pinRepeat.
  ///
  /// In tr, this message translates to:
  /// **'PIN (Tekrar)'**
  String get pinRepeat;

  /// No description provided for @createAndEnter.
  ///
  /// In tr, this message translates to:
  /// **'Oluştur ve Gir'**
  String get createAndEnter;

  /// No description provided for @pinLengthError.
  ///
  /// In tr, this message translates to:
  /// **'PIN {length} haneli olmalı.'**
  String pinLengthError(int length);

  /// No description provided for @pinMismatch.
  ///
  /// In tr, this message translates to:
  /// **'PIN ve onay eşleşmiyor.'**
  String get pinMismatch;

  /// No description provided for @pinWrong.
  ///
  /// In tr, this message translates to:
  /// **'Hatalı PIN.'**
  String get pinWrong;

  /// No description provided for @forgotPin.
  ///
  /// In tr, this message translates to:
  /// **'PIN\'i mi unuttunuz?'**
  String get forgotPin;

  /// No description provided for @resetPinTitle.
  ///
  /// In tr, this message translates to:
  /// **'PIN\'i Sıfırla'**
  String get resetPinTitle;

  /// No description provided for @recoveryPrompt.
  ///
  /// In tr, this message translates to:
  /// **'Sıfırlamak için kurtarma kodunu girin. Bu kod işletme yöneticisindedir.'**
  String get recoveryPrompt;

  /// No description provided for @recoveryCode.
  ///
  /// In tr, this message translates to:
  /// **'Kurtarma Kodu'**
  String get recoveryCode;

  /// No description provided for @reset.
  ///
  /// In tr, this message translates to:
  /// **'Sıfırla'**
  String get reset;

  /// No description provided for @recoveryCodeWrong.
  ///
  /// In tr, this message translates to:
  /// **'Kurtarma kodu hatalı.'**
  String get recoveryCodeWrong;

  /// No description provided for @pinResetDone.
  ///
  /// In tr, this message translates to:
  /// **'PIN sıfırlandı. Yeni PIN belirleyin.'**
  String get pinResetDone;

  /// No description provided for @settingsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar'**
  String get settingsTitle;

  /// No description provided for @userGuide.
  ///
  /// In tr, this message translates to:
  /// **'Kullanma Kılavuzu'**
  String get userGuide;

  /// No description provided for @theme.
  ///
  /// In tr, this message translates to:
  /// **'Tema'**
  String get theme;

  /// No description provided for @themeSystem.
  ///
  /// In tr, this message translates to:
  /// **'Sistem'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In tr, this message translates to:
  /// **'Açık'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In tr, this message translates to:
  /// **'Koyu'**
  String get themeDark;

  /// No description provided for @guidePurposeTitle.
  ///
  /// In tr, this message translates to:
  /// **'Uygulamanın Amacı'**
  String get guidePurposeTitle;

  /// No description provided for @guidePurposeBody.
  ///
  /// In tr, this message translates to:
  /// **'Coffee Shop & Loyalty, bir kahve dükkânının menüsünü sunan ve müşterilere her alışverişte puan kazandıran bir sadakat (loyalty) uygulamasıdır. Amaç, müşteri bağlılığını artırmak ve sipariş sürecini kolaylaştırmaktır.'**
  String get guidePurposeBody;

  /// No description provided for @guideUsageTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ne İçin Kullanılır?'**
  String get guideUsageTitle;

  /// No description provided for @guideUsageBody.
  ///
  /// In tr, this message translates to:
  /// **'Müşteriler menüden ürün seçer, boyut belirler ve sepete ekler. Sipariş tamamlandığında kazandıkları puanlar hesaplarına işlenir. Kayıtlı üyeler puanlarını biriktirerek seviye atlar; misafirler ise hızlıca sipariş verebilir. İşletme yetkilisi ürün ve üyeleri yönetebilir.'**
  String get guideUsageBody;

  /// No description provided for @guideFeaturesTitle.
  ///
  /// In tr, this message translates to:
  /// **'Özellikler ve Seçenekler'**
  String get guideFeaturesTitle;

  /// No description provided for @guideFeatureHome.
  ///
  /// In tr, this message translates to:
  /// **'Ana Sayfa: Menüyü görüntüleyin, kahve arayın, boyut seçip sepete ekleyin.'**
  String get guideFeatureHome;

  /// No description provided for @guideFeatureCart.
  ///
  /// In tr, this message translates to:
  /// **'Sepetim: Seçtiğiniz ürünleri görün, toplam tutarı ve kazanacağınız puanı kontrol edin, siparişi tamamlayın.'**
  String get guideFeatureCart;

  /// No description provided for @guideFeatureProfile.
  ///
  /// In tr, this message translates to:
  /// **'Profilim: Puanınızı, üyelik seviyenizi ve hesap bilgilerinizi görün.'**
  String get guideFeatureProfile;

  /// No description provided for @guideFeatureOrders.
  ///
  /// In tr, this message translates to:
  /// **'Sipariş Geçmişim: Geçmiş siparişlerinizi tarih ve detaylarıyla inceleyin.'**
  String get guideFeatureOrders;

  /// No description provided for @guideFeatureAdmin.
  ///
  /// In tr, this message translates to:
  /// **'Admin Paneli: PIN korumalı yönetim ekranı — ürün ve üye ekleme/düzenleme, istatistikler.'**
  String get guideFeatureAdmin;

  /// No description provided for @guideFeatureSettings.
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar: Dil (TR/EN) ve tema (Sistem/Açık/Koyu) tercihlerini değiştirin.'**
  String get guideFeatureSettings;

  /// No description provided for @adminPanel.
  ///
  /// In tr, this message translates to:
  /// **'Admin Paneli'**
  String get adminPanel;

  /// No description provided for @changePin.
  ///
  /// In tr, this message translates to:
  /// **'PIN Değiştir'**
  String get changePin;

  /// No description provided for @currentPin.
  ///
  /// In tr, this message translates to:
  /// **'Mevcut PIN'**
  String get currentPin;

  /// No description provided for @newPin4.
  ///
  /// In tr, this message translates to:
  /// **'Yeni PIN (4 hane)'**
  String get newPin4;

  /// No description provided for @currentPinWrong.
  ///
  /// In tr, this message translates to:
  /// **'Mevcut PIN hatalı.'**
  String get currentPinWrong;

  /// No description provided for @newPin4Error.
  ///
  /// In tr, this message translates to:
  /// **'Yeni PIN 4 haneli olmalı.'**
  String get newPin4Error;

  /// No description provided for @pinUpdated.
  ///
  /// In tr, this message translates to:
  /// **'PIN güncellendi.'**
  String get pinUpdated;

  /// No description provided for @tabSummary.
  ///
  /// In tr, this message translates to:
  /// **'Özet'**
  String get tabSummary;

  /// No description provided for @tabProducts.
  ///
  /// In tr, this message translates to:
  /// **'Ürünler'**
  String get tabProducts;

  /// No description provided for @tabMembers.
  ///
  /// In tr, this message translates to:
  /// **'Üyeler'**
  String get tabMembers;

  /// No description provided for @statProducts.
  ///
  /// In tr, this message translates to:
  /// **'Ürün'**
  String get statProducts;

  /// No description provided for @statMembers.
  ///
  /// In tr, this message translates to:
  /// **'Üye'**
  String get statMembers;

  /// No description provided for @statMenuTotal.
  ///
  /// In tr, this message translates to:
  /// **'Menü Toplam'**
  String get statMenuTotal;

  /// No description provided for @statPointsGiven.
  ///
  /// In tr, this message translates to:
  /// **'Dağıtılan Puan'**
  String get statPointsGiven;

  /// No description provided for @loyalCustomers.
  ///
  /// In tr, this message translates to:
  /// **'🏆 En Sadık Müşteriler'**
  String get loyalCustomers;

  /// No description provided for @noMembersYet.
  ///
  /// In tr, this message translates to:
  /// **'Henüz üye yok'**
  String get noMembersYet;

  /// No description provided for @productsByCategory.
  ///
  /// In tr, this message translates to:
  /// **'📊 Kategoriye Göre Ürünler'**
  String get productsByCategory;

  /// No description provided for @noProductsYet.
  ///
  /// In tr, this message translates to:
  /// **'Henüz ürün eklenmemiş'**
  String get noProductsYet;

  /// No description provided for @noRegisteredMembers.
  ///
  /// In tr, this message translates to:
  /// **'Henüz kayıtlı üye yok'**
  String get noRegisteredMembers;

  /// No description provided for @deleteProduct.
  ///
  /// In tr, this message translates to:
  /// **'Ürünü Sil'**
  String get deleteProduct;

  /// No description provided for @deleteMember.
  ///
  /// In tr, this message translates to:
  /// **'Üyeyi Sil'**
  String get deleteMember;

  /// No description provided for @deleteConfirm.
  ///
  /// In tr, this message translates to:
  /// **'{name} silinecek. Emin misiniz?'**
  String deleteConfirm(Object name);

  /// No description provided for @delete.
  ///
  /// In tr, this message translates to:
  /// **'Sil'**
  String get delete;

  /// No description provided for @phoneNone.
  ///
  /// In tr, this message translates to:
  /// **'Telefon yok'**
  String get phoneNone;

  /// No description provided for @nameAndPriceRequired.
  ///
  /// In tr, this message translates to:
  /// **'Ürün adı ve fiyat zorunludur!'**
  String get nameAndPriceRequired;

  /// No description provided for @nameSurnameRequired.
  ///
  /// In tr, this message translates to:
  /// **'Ad ve soyad zorunludur!'**
  String get nameSurnameRequired;

  /// No description provided for @productAdded.
  ///
  /// In tr, this message translates to:
  /// **'{name} eklendi!'**
  String productAdded(Object name);

  /// No description provided for @nameUpdated.
  ///
  /// In tr, this message translates to:
  /// **'{name} güncellendi!'**
  String nameUpdated(Object name);

  /// No description provided for @editProduct.
  ///
  /// In tr, this message translates to:
  /// **'Ürünü Düzenle'**
  String get editProduct;

  /// No description provided for @editMember.
  ///
  /// In tr, this message translates to:
  /// **'Üyeyi Düzenle'**
  String get editMember;

  /// No description provided for @imageUrl.
  ///
  /// In tr, this message translates to:
  /// **'Görsel URL'**
  String get imageUrl;

  /// No description provided for @photoUrl.
  ///
  /// In tr, this message translates to:
  /// **'Resim URL'**
  String get photoUrl;

  /// No description provided for @update.
  ///
  /// In tr, this message translates to:
  /// **'Güncelle'**
  String get update;

  /// No description provided for @productCount.
  ///
  /// In tr, this message translates to:
  /// **'{count} ürün'**
  String productCount(int count);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
