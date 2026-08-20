# Sürüm Notları — Üretim (Production) Yayını

Play Console → Production → yeni sürüm oluştururken "Release notes" alanına
aşağıdaki metinler yapıştırılır (dil başına en fazla 500 karakter).

> Not: Bu, uygulamanın kamuya ilk çıkışı olduğundan sürüm notu bir değişiklik
> listesi değil, uygulamanın ne yaptığını yeni kullanıcıya anlatan tanıtım
> metnidir. (Kapalı test için değişiklik-listesi notları ayrı dosyalarda:
> surum-notlari-1.3.2.md, surum-notlari-1.3.3.md.) Üretime hangi build
> yükselirse (ör. 1.3.2+8 veya 1.3.3+9) bu notlar onunla birlikte kullanılır.

## tr-TR

```
Coffee Shop & Loyalty ile her siparişte puan kazan, puanlarını dilediğin ürüne dönüştür!

• Sıcak, soğuk ve tatlı menüde kolay gezinme
• Üye ol, sipariş ver, otomatik puan biriktir
• "Ödüllerim" ile puanınla ürün al
• Boyut seçimi (Küçük/Orta/Büyük) ve sepet
• Açık/Koyu tema, Türkçe ve İngilizce
• Verilerin cihazında kalır, çevrimdışı çalışır
```

## en-US

```
Earn points on every order with Coffee Shop & Loyalty and turn them into rewards!

• Easily browse hot, cold and dessert menus
• Sign up, order, and collect points automatically
• Redeem products with your points in "My Rewards"
• Size selection (Small/Medium/Large) and cart
• Light/Dark theme, Turkish and English
• Your data stays on your device and works offline
```

## Yayın öncesi hatırlatmalar

- Play Console → İçerik (App content): Gizlilik politikası URL'si girili olmalı
  (gh-pages: https://ibrahimyasar68.github.io/coffee_shop_loyalty/privacy-policy-tr.html)
- Mağaza girişi: yeni ekran görüntüleri (store_screenshots/framed/) yüklü olmalı
- Üretime yükselecek .aab, imzalı ve kurtarma kodu (1.3.2+8 ile AYNI) ile derlenmiş olmalı:
  `flutter build appbundle --release --dart-define=ADMIN_RECOVERY_CODE=<GİZLİ-KOD>`
- Üretim, ülke/bölge kapsamı ve aşamalı dağıtım (staged rollout) oranını gözden geçir.
