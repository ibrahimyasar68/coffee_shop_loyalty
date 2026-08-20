# Sürüm Notları — 1.3.3 (versionCode 9)

Play Console → Closed testing → yeni sürüm oluştururken "Release notes"
alanına aşağıdaki metinler yapıştırılır (dil başına en fazla 500 karakter).

> Not: 1.3.2+8 Play'e yüklendiği için aynı versionCode tekrar yüklenemez;
> bu sürüm versionCode 9 olarak çıkar. Uygulamaya dokunan tek değişiklik
> menüdeki Latte ürün görselinin düzeltilmesidir (yanlış bir görsele
> işaret ediyordu). Ekran görüntüsü yenileme ve gizlilik politikası
> mağaza girişi tarafındadır; binary'i etkilemez.

## tr-TR

```
Bu sürümdeki iyileştirmeler:
• Menüdeki ürün görselleri düzeltildi ve netleştirildi
• Küçük hata düzeltmeleri ve kararlılık iyileştirmeleri
```

## en-US

```
Improvements in this release:
• Fixed and refreshed product images in the menu
• Minor bug fixes and stability improvements
```

## Yükleme sonrası test edilecekler (testerlara duyurulabilir)

1. Menüde ürün görsellerinin doğru göründüğünü kontrol etmek (özellikle Latte)
2. "Ödüllerim" ve ürün detayında görsellerin doğru yüklendiğini doğrulamak

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
