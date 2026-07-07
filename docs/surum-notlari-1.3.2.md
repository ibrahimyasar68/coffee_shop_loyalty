# Sürüm Notları — 1.3.2 (versionCode 8)

Play Console → Closed testing → yeni sürüm oluştururken "Release notes"
alanına aşağıdaki metinler yapıştırılır (dil başına en fazla 500 karakter).

## tr-TR

```
Bu sürümdeki yenilikler:
• Ana sayfa artık liste görünümünde — ürünleri görmek daha kolay
• Yeni "Ödüllerim" sayfası: puanınla alabileceğin ürünleri seç ve kullan
• Yeterli puanın olduğunda ana sayfada ödül hatırlatması çıkıyor
• Ürün eklerken yeni "Diğer" kategorisi
• Boyut seçimi (Küçük/Orta/Büyük) yalnızca sıcak ve soğuk içeceklerde
```

## en-US

```
What's new in this release:
• Home screen now uses a list view — easier to browse products
• New "My Rewards" page: pick and redeem products with your points
• A reward reminder appears on the home screen when you have enough points
• New "Other" category when adding products
• Size selection (Small/Medium/Large) only for hot and cold drinks
```

## Yükleme sonrası test edilecekler (testerlara duyurulabilir)

1. Ana sayfanın liste görünümünde ürünleri gezmek
2. Üye girişiyle puan biriktirip ana sayfadaki ödül banner'ına dokunmak
3. "Ödüllerim" sayfasında yeterli puanı olan ürünü "Kullan" ile almak;
   sipariş geçmişinde "🎁 ... (Ödül)" kaydını görmek
4. Tatlı/Diğer bir ürünün detayında boyut seçeneğinin çıkmadığını doğrulamak

## Build bilgisi

- Dosya: `build/app/outputs/bundle/release/app-release.aab` (1.3.2+8)
  (masaüstüne kopyası: `~/Desktop/coffeesweet-1.3.2+8.aab`)
- Build komutu (kurtarma kodu dahil — sonraki sürümlerde de aynı kod geçilmeli):
  `flutter build appbundle --release --dart-define=ADMIN_RECOVERY_CODE=<GİZLİ-KOD>`
- Kurtarma kodunun kendisi repoya yazılmaz; şifre yöneticinde saklı tut.
