import 'package:coffee_shop_loyalty/utils/ads_service.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Alt navigasyon çubuğunun üstünde duran sabit banner reklam.
///
/// Reklam yüklenene kadar hiç yer kaplamaz; böylece açılışta veya yükleme
/// başarısız olduğunda ekranda boşluk/zıplama oluşmaz.
class AdBanner extends StatefulWidget {
  const AdBanner({super.key});

  @override
  State<AdBanner> createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  BannerAd? _ad;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await AdsService.initialize();
    if (!mounted) return;

    final ad = AdsService.createBannerAd(
      onLoaded: () {
        if (mounted) setState(() => _loaded = true);
      },
      onFailed: () {
        // Reklam servis tarafında dispose edildi; referansı bırak.
        if (mounted) {
          setState(() {
            _ad = null;
            _loaded = false;
          });
        }
      },
    );
    _ad = ad;
    await ad.load();
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ad = _ad;
    if (!_loaded || ad == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      height: ad.size.height.toDouble(),
      color: Theme.of(context).scaffoldBackgroundColor,
      alignment: Alignment.center,
      child: SizedBox(
        width: ad.size.width.toDouble(),
        height: ad.size.height.toDouble(),
        child: AdWidget(ad: ad),
      ),
    );
  }
}
