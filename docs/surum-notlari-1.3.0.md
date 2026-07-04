# Sürüm Notları — 1.3.0 (versionCode 6)

Play Console → Closed testing → yeni sürüm oluştururken "Release notes"
alanına aşağıdaki metinler yapıştırılır (dil başına en fazla 500 karakter).

## tr-TR

```
Bu sürümdeki yenilikler:
• Koyu tema tamamen düzeltildi — tüm ekranlar artık koyu temada doğru görünüyor
• Ödül kullanma eklendi: 100 puan biriktirince profilden 1 bedava kahve kullanabilirsin
• Yanlışlıkla çıkışı önlemek için çıkış onayı eklendi
• Butonlar büyütüldü, kontrast iyileştirildi (erişilebilirlik)
• Güvenlik iyileştirmeleri (admin PIN koruması güçlendirildi)
```

## en-US

```
What's new in this release:
• Dark theme fully fixed — every screen now renders correctly in dark mode
• Reward redemption added: collect 100 points and redeem 1 free coffee from your profile
• Logout confirmation added to prevent accidental sign-outs
• Bigger touch targets and improved contrast (accessibility)
• Security improvements (stronger admin PIN protection)
```

## Yükleme sonrası test edilecekler (testerlara duyurulabilir)

1. Ayarlar → Koyu tema seçip tüm ekranları gezmek
2. Üye girişiyle 100+ puan biriktirip Profil → "Ödülü Kullan" akışı
3. Ana sayfada geri tuşu → çıkış onayı görünmeli
4. Sipariş geçmişinde "🎁 Bedava Kahve (Ödül)" kaydının görünmesi

## Build bilgisi

- Dosya: `build/app/outputs/bundle/release/app-release.aab` (1.3.0+6)
- Build komutu (kurtarma kodu dahil — sonraki sürümlerde de aynı kod geçilmeli):
  `flutter build appbundle --release --dart-define=ADMIN_RECOVERY_CODE=<GİZLİ-KOD>`
- Kurtarma kodunun kendisi repoya yazılmaz; şifre yöneticinde saklı tut.
