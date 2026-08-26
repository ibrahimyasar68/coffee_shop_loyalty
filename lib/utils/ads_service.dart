import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';

/// AdMob reklamlarının tek toplandığı yer: SDK başlatma, banner üretme ve
/// tam ekran (interstitial) reklamı sıklık sınırıyla gösterme.
///
/// Ad Unit ID'leri build moduna göre otomatik seçilir: debug'da Google'ın
/// resmî test ID'leri, release'de gerçek ID'ler. Geliştirme sırasında kendi
/// gerçek reklamına tıklamak AdMob hesabının kapatılmasına yol açtığından
/// bu ayrım zorunludur.
///
/// Sıklık sayacı [AdminSecurity] ile aynı mekanizmada — Hive 'settings_box'
/// kutusunda — tutulur.
class AdsService {
  AdsService._();

  // ── Ad Unit ID'leri ────────────────────────────────────────────────
  // Google'ın herkese açık test ID'leri — debug build'de bunlar kullanılır.
  static const _testBannerAndroid = 'ca-app-pub-3940256099942544/6300978111';
  static const _testBannerIos = 'ca-app-pub-3940256099942544/2934735716';
  static const _testInterstitialAndroid =
      'ca-app-pub-3940256099942544/1033173712';
  static const _testInterstitialIos = 'ca-app-pub-3940256099942544/4411468910';

  // Gerçek Ad Unit ID'leri — release build'de bunlar kullanılır.
  // AdMob → Reklam birimleri: "Ana ekran alt banner" ve "Sipariş tamamlama geçiş".
  static const _realBannerAndroid = 'ca-app-pub-2349446548941129/8965874770';
  static const _realInterstitialAndroid =
      'ca-app-pub-2349446548941129/2807660537';

  // iOS sürümü planlanmıyor; çıkılacak olursa AdMob'da ayrı bir uygulama
  // kaydı açılıp bu iki değerin iOS karşılıkları buraya yazılmalı.
  static const _realBannerIos = 'ca-app-pub-0000000000000000/0000000000';
  static const _realInterstitialIos = 'ca-app-pub-0000000000000000/0000000000';

  /// Tam ekran reklam kaç tamamlanan siparişte bir gösterilsin.
  /// Her siparişte göstermek kullanıcıyı yorar ve uygulamayı sildirir.
  static const _interstitialFrequency = 3;

  static const _completionCountKey = 'ads_completion_count';

  static Future<void>? _initFuture;
  static InterstitialAd? _interstitial;
  static bool _interstitialLoading = false;

  /// AdMob yalnızca mobil platformlarda çalışır.
  static bool get _supported => Platform.isAndroid || Platform.isIOS;

  static Box? get _settings =>
      Hive.isBoxOpen('settings_box') ? Hive.box('settings_box') : null;

  static String get bannerAdUnitId {
    if (kDebugMode) {
      return Platform.isAndroid ? _testBannerAndroid : _testBannerIos;
    }
    return Platform.isAndroid ? _realBannerAndroid : _realBannerIos;
  }

  static String get interstitialAdUnitId {
    if (kDebugMode) {
      return Platform.isAndroid
          ? _testInterstitialAndroid
          : _testInterstitialIos;
    }
    return Platform.isAndroid ? _realInterstitialAndroid : _realInterstitialIos;
  }

  /// SDK'yı uygulama ömrü boyunca bir kez başlatır; sonraki çağrılar aynı
  /// future'ı döndürür. Reklam tarafındaki bir hata uygulamanın açılışını
  /// engellememeli, bu yüzden hatalar burada yutulur.
  static Future<void> initialize() => _initFuture ??= _initialize();

  static Future<void> _initialize() async {
    if (!_supported) return;
    try {
      await MobileAds.instance.initialize();
      // İlk tam ekran reklamı şimdiden hazırla — gösterim anında beklenmesin.
      await loadInterstitial();
    } catch (e) {
      debugPrint('AdMob başlatılamadı: $e');
    }
  }

  /// Her ekran kendi banner örneğini buradan alır. Dönen reklamın [BannerAd.load]
  /// çağrısı ve [BannerAd.dispose] sorumluluğu çağıran widget'a aittir.
  static BannerAd createBannerAd({
    required VoidCallback onLoaded,
    VoidCallback? onFailed,
  }) {
    return BannerAd(
      size: AdSize.banner,
      adUnitId: bannerAdUnitId,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => onLoaded(),
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          debugPrint('Banner reklam yüklenemedi: $error');
          onFailed?.call();
        },
      ),
    );
  }

  /// Bir sonraki tam ekran reklamı önceden yükleyip hazırda bekletir.
  static Future<void> loadInterstitial() async {
    if (!_supported || _interstitial != null || _interstitialLoading) return;
    _interstitialLoading = true;
    try {
      await InterstitialAd.load(
        adUnitId: interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            _interstitial = ad;
            _interstitialLoading = false;
          },
          onAdFailedToLoad: (error) {
            _interstitial = null;
            _interstitialLoading = false;
            debugPrint('Tam ekran reklam yüklenemedi: $error');
          },
        ),
      );
    } catch (e) {
      _interstitialLoading = false;
      debugPrint('Tam ekran reklam isteği başarısız: $e');
    }
  }

  /// Kullanıcı bir siparişi tamamladığında çağrılır (yalnızca yeni sipariş —
  /// ödül kullanma, gezinme veya düzenleme akışlarına bağlanmaz).
  ///
  /// Sayaç [_interstitialFrequency] katına ulaşmadıysa hiçbir şey yapmaz,
  /// yalnızca bir sonraki reklamı hazırlar. Ulaştıysa reklamı gösterir ve
  /// kapatılana kadar bekler; böylece çağıran taraf ekran geçişini reklam
  /// kapandıktan sonra yapabilir.
  static Future<void> onOrderCompleted() async {
    if (!_supported) return;
    final box = _settings;
    final count = ((box?.get(_completionCountKey) as int?) ?? 0) + 1;
    await box?.put(_completionCountKey, count);

    if (count % _interstitialFrequency != 0) {
      await loadInterstitial();
      return;
    }
    await _showInterstitial();
  }

  static Future<void> _showInterstitial() async {
    final ad = _interstitial;
    // Reklam henüz hazır değilse bu tamamlamayı sessizce geç; kullanıcıyı
    // yükleme için bekletmek sipariş akışını bozar.
    if (ad == null) {
      await loadInterstitial();
      return;
    }
    _interstitial = null;

    final closed = Completer<void>();
    void complete(InterstitialAd shown) {
      shown.dispose();
      if (!closed.isCompleted) closed.complete();
    }

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: complete,
      onAdFailedToShowFullScreenContent: (shown, error) {
        debugPrint('Tam ekran reklam gösterilemedi: $error');
        complete(shown);
      },
    );

    try {
      await ad.show();
      // Geri çağrı hiç gelmezse sipariş akışı kilitlenmesin diye üst sınır.
      await closed.future.timeout(const Duration(minutes: 2), onTimeout: () {});
    } catch (e) {
      debugPrint('Tam ekran reklam hatası: $e');
    } finally {
      await loadInterstitial();
    }
  }
}
