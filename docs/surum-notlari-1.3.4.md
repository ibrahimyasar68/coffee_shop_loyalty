# Sürüm Notları — 1.3.4 (versionCode 10)

Play Console → Üretim (Production) → yeni sürüm oluştururken "Release notes"
alanına aşağıdaki metinler yapıştırılır (dil başına en fazla 500 karakter).

> Not: Canlıdaki sürüm 1.3.3+9 olduğundan bu sürüm versionCode 10 olarak çıkar.
> Bu sürümdeki değişiklikler:
> (1) Android 15 ve üstünde alt gezinme çubuğunun ekranın alt kısmını örtmesi
> düzeltildi: sepet, ürün detayı, profil, ödüller, sipariş geçmişi, ayarlar,
> kullanım kılavuzu, üye seçimi, yeni ürün/üye formları ve admin ekranları
> (düzenleme pencereleri dahil) artık sistem çubuğunun yüksekliği kadar pay bırakıyor.
> Android 14 ve altında çubuk zaten opak olduğundan orada görünüm değişmez.
> (2) Uygulamanın cihazdaki adı her yerde "CoffeeShop" oldu (eskiden
> `coffee_shop_loyalty` görünüyordu).
> (3) Geçiş reklamı hazır değilken (no fill) gösterim sırası artık boşa gitmiyor;
> bir sonraki siparişte yeniden deneniyor.
>
> Reklam, veri güvenliği ve gizlilik politikası beyanlarında değişiklik yok.

## tr-TR

```
Bu sürümdeki değişiklikler:
• Bazı cihazlarda alt gezinme çubuğunun altında kalan "Siparişi Tamamla", "Sepete Ekle" gibi düğmeler ve liste sonları artık tamamen görünüyor ve kolayca dokunulabiliyor
• Uygulamanın cihazdaki adı "CoffeeShop" olarak düzeltildi
• Küçük hata düzeltmeleri ve kararlılık iyileştirmeleri
```

## en-US

```
What's new in this release:
• On some devices, buttons such as "Complete Order" and "Add to Cart" and the end of lists were hidden behind the navigation bar; they are now fully visible and easy to tap
• The app name on your device is now shown as "CoffeeShop"
• Minor bug fixes and stability improvements
```

## Yükleme sonrası test edilecekler

Mümkünse **Android 15 veya üstü** bir telefonda, **3 tuşlu gezinme** açıkken
(Ayarlar → Sistem → Hareketler → Sistem gezinmesi) denenmeli; sorun en çok bu
kurulumda görünüyordu.

1. Sepet: "Siparişi Tamamla" düğmesinin tamamı gezinme çubuğunun üstünde mi?
2. Ürün detayı: en alta kaydırınca "Sepete Ekle" tamamen görünüyor mu?
3. Profil: en alttaki "Çıkış Yap" satırına rahatça dokunulabiliyor mu?
4. Sipariş geçmişi, Ödüllerim, Ayarlar, Kullanım Kılavuzu ve Üye Seçimi:
   listenin son öğesi çubuğun altında kalmıyor mu?
5. Admin paneli: ürün/üye düzenleme pencerelerinde "Kaydet" düğmesi hem klavye
   kapalıyken hem açıkken görünüyor mu? (Klavye açıkken fazladan boşluk
   oluşmamalı.)
6. Android 14 veya altı bir cihazda (ör. Galaxy Note 8) ekranların altında
   gereksiz boşluk oluşmadığını kontrol etmek.
7. Ana ekranda uygulama adının "CoffeeShop" göründüğünü doğrulamak.
8. Ana sayfadaki banner reklamın ve 3. siparişten sonraki tam ekran reklamın
   önceki gibi çalıştığını doğrulamak. Kendi reklamına TIKLAMA.

## Build bilgisi

- Sürüm: `pubspec.yaml` → `version: 1.3.4+10`
- Build komutu (kurtarma kodu önceki sürümlerle AYNI olmalı, yoksa sahadaki
  cihazlarda admin kurtarma kodu değişir):
  `flutter build appbundle --release --dart-define=ADMIN_RECOVERY_CODE=<GİZLİ-KOD>`
- Çıktı: `build/app/outputs/bundle/release/app-release.aab` (1.3.4+10)
- Kurtarma kodunun kendisi repoya yazılmaz; şifre yöneticinde saklı tut.
