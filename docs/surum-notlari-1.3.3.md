# Sürüm Notları — 1.3.3 (versionCode 9)

Play Console → Closed testing → yeni sürüm oluştururken "Release notes"
alanına aşağıdaki metinler yapıştırılır (dil başına en fazla 500 karakter).

> Not: 1.3.2+8 Play'e yüklendiği için aynı versionCode tekrar yüklenemez;
> bu sürüm versionCode 9 olarak çıkar. Bu sürümdeki iki değişiklik:
> (1) menüdeki Latte ürün görselinin düzeltilmesi, (2) Google AdMob
> reklam entegrasyonu (alt banner + sipariş sonrası sıklık sınırlı tam
> ekran reklam).
>
> ⚠️ Reklam eklendiği için Play Console'da **Ads**, **Advertising ID** ve
> **Data safety** beyanları güncellenmelidir — bkz. `play-data-safety-reklam.md`.
> Gizlilik politikası da 26 Ağustos 2026'da reklam bölümüyle güncellendi.

## tr-TR

```
Bu sürümdeki değişiklikler:
• Menüdeki ürün görselleri düzeltildi ve netleştirildi
• Uygulamada reklam gösterimi başladı; uygulamayı ücretsiz tutmamıza yardımcı oluyor
• Küçük hata düzeltmeleri ve kararlılık iyileştirmeleri
```

## en-US

```
What's new in this release:
• Fixed and refreshed product images in the menu
• Ads are now shown in the app, which helps keep it free
• Minor bug fixes and stability improvements
```

## Yükleme sonrası test edilecekler (testerlara duyurulabilir)

1. Menüde ürün görsellerinin doğru göründüğünü kontrol etmek (özellikle Latte)
2. "Ödüllerim" ve ürün detayında görsellerin doğru yüklendiğini doğrulamak
3. Ana ekranda alt çubuğun hemen üstünde banner reklamın göründüğünü doğrulamak
4. Üst üste 3 sipariş tamamlayıp 3. siparişten sonra tam ekran reklamın geldiğini,
   reklam kapatılınca sipariş onay ekranının açıldığını doğrulamak
5. Reklamların sekme geçişlerinde veya ödül kullanırken ÇIKMADIĞINI doğrulamak
6. Reklamların "Test Ad" etiketi taşımadığını doğrulamak (release build'de gerçek
   reklam gelmeli). Kendi reklamına TIKLAMA — AdMob hesabı kapatılabilir.

> Not: Görsel düzeltmesi yalnızca yeni kurulumlarda otomatik gelir (seed verisi
> boş veritabanında çalışır). Mevcut cihazında eski görsel duran testerlar için,
> uygulamayı kaldırıp yeniden kurmak veya admin panelinden ürün görselini
> güncellemek gerekir.

## Build bilgisi

- Önce sürümü yükselt: `pubspec.yaml` → `version: 1.3.3+9`
- Build komutu (kurtarma kodu dahil — 1.3.2+8 ile AYNI kod geçilmeli, yoksa
  sahadaki cihazlarda admin kurtarma kodu değişir):
  `flutter build appbundle --release --dart-define=ADMIN_RECOVERY_CODE=<GİZLİ-KOD>`
- Çıktı: `build/app/outputs/bundle/release/app-release.aab` (1.3.3+9)
- Kurtarma kodunun kendisi repoya yazılmaz; şifre yöneticinde saklı tut.
