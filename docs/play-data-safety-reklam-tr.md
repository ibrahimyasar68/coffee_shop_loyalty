# Play Console — Reklam Sonrası Beyan Kılavuzu (1.3.3+9) · Türkçe Arayüz

`play-data-safety-reklam.md` dosyasının, **Play Console'u Türkçe kullananlar için**
hazırlanmış sürümü. İçerik aynıdır; yalnızca menü ve soru adları Türkçe arayüzdeki
karşılıklarıyla verilmiştir. Google etiketleri zaman zaman değiştirdiği için
İngilizce orijinaller parantez içinde bırakıldı — hangisini görürseniz onu takip edin.

Sıra önemli: **beyanları AAB yüklemeden önce** tamamlarsan sürüm incelemesi tek turda biter.

---

## 1) Uygulama içeriği → Reklamlar
*(App content → Ads)*

| Soru | Cevap |
|---|---|
| Uygulamanız reklam içeriyor mu? *(Does your app contain ads?)* | **Evet** |

> Sonuç: Mağaza girişinde **"Reklam içerir"** *(Contains ads)* etiketi görünür.
> Bu, kullanıcıya gösterilen kalıcı bir etikettir; reklam kaldırılmadan geri alınamaz.

---

## 2) Uygulama içeriği → Reklam kimliği
*(App content → Advertising ID)*

| Soru | Cevap |
|---|---|
| Uygulamanız reklam kimliği kullanıyor mu? *(Does your app use advertising ID?)* | **Evet** |
| Kullanım amacı *(birden fazla seçilebilir)* | **Reklamcılık veya pazarlama** *(Advertising or marketing)* |
| Diğer amaçlar: Analiz *(Analytics)*, Dolandırıcılık önleme *(Fraud prevention)* … | **İşaretleme** — uygulamada analitik yok |

> Gerekçe: `AndroidManifest.xml` içinde `com.google.android.gms.permission.AD_ID`
> izni bildirildi ve google_mobile_ads bu kimliği kullanıyor. Beyan edilmezse
> sürüm reddedilir.

---

## 3) Uygulama içeriği → Veri güvenliği
*(App content → Data safety)*

Bu bölüm 1.3.2'de **"Veri toplanmıyor"** *(No data collected)* olarak beyan
edilmişti. Reklamla birlikte bu artık **doğru değil** — mutlaka güncellenmeli.

### 3a. Genel sorular

| Soru | Cevap |
|---|---|
| Uygulamanız, zorunlu kullanıcı verisi türlerinden herhangi birini topluyor veya paylaşıyor mu? *(Does your app collect or share any of the required user data types?)* | **Evet** |
| Uygulamanızın topladığı tüm kullanıcı verileri aktarım sırasında şifreleniyor mu? *(…encrypted in transit?)* | **Evet** — AdMob istekleri HTTPS |
| Kullanıcılara verilerinin silinmesini talep etme imkânı sunuyor musunuz? *(…request that their data is deleted?)* | **Hayır** — veriler cihazda tutulur, uygulama kaldırılınca silinir. Açıklama alanına bu not yazılabilir. |

### 3b. Veri türleri — SADECE şu tek kalem işaretlenecek

**Cihaz veya diğer kimlikler → Cihaz veya diğer kimlikler**
*(Device or other IDs → Device or other IDs)*

| Alan | Cevap |
|---|---|
| Toplanıyor *(Collected)* | **Evet** |
| Paylaşılıyor *(Shared)* | **Evet** — Google/AdMob ile |
| Geçici olarak işleniyor *(Processed ephemerally)* | **Hayır** |
| Zorunlu mu, isteğe bağlı mı *(Required or optional)* | **Veri toplama zorunludur** *(Data collection is required)* — kullanıcı reddedemiyor |
| Amaçlar *(Purposes)* | **Reklamcılık veya pazarlama** *(Advertising or marketing)* |

### 3c. İşaretlenMEyecekler (yanlışlıkla seçilmesin)

Aşağıdaki veriler cihazdan hiç çıkmıyor — Hive'da yerel saklanıyor. Play'in
tanımına göre **"toplanıyor" sayılmaz**, çünkü ağ üzerinden hiçbir yere iletilmiyor:

- **Kişisel bilgiler** *(Personal info)* → Ad *(Name)*, Telefon numarası *(Phone number)* — yerel üyelik kaydı
- **Fotoğraflar ve videolar** *(Photos and videos)* — yalnızca URL referansı
- **Uygulama etkinliği** *(App activity)* → Satın alma geçmişi *(Purchase history)* — sipariş geçmişi yerel
- **Konum** *(Location)*, **Kişiler** *(Contacts)*, **Mesajlar** *(Messages)*, **Finansal bilgiler** *(Financial info)* → hiçbiri yok

> Not: Play, "toplanıyor" tanımını **cihazdan sunucuya aktarım** üzerinden yapar.
> Yalnızca cihazda kalan veri beyan edilmez. Emin olmak istersen formdaki
> "Daha fazla bilgi" *(Learn more)* bağlantısındaki tanımı okuyup kararı kendin ver.

---

## 4) Uygulama içeriği → Hedef kitle ve içerik
*(App content → Target audience and content)*

| Soru | Cevap |
|---|---|
| Hedef yaş grubu *(Target age group)* | **13-15 + 16-17 + 18 yaş ve üstü** (seçilen: 13+) |
| "Google'ın küçük olduğunu belirlediği kullanıcıların uygulamama erişimini kısıtla" *(isteğe bağlı)* | **İşaretsiz** |

> ⚠️ Yaş grubuna 13 altı dahil edilirse Google Play **Aile Programı**
> *(Families)* politikası devreye girer; bu durumda kullandığımız standart AdMob
> birimleri uygun olmaz, sertifikalı reklam ağı + `setTagForChildDirectedTreatment`
> gerekir. Kahve dükkânı uygulaması için 13+ doğru cevaptır.

> ⚠️ "Küçük olduğu belirlenen kullanıcıların erişimini kısıtla" kutusu isteğe
> bağlıdır ve işaretlenirse 18 altı yaş gruplarını seçmek mümkün olmaz — yani
> lise çağındaki müşteriler uygulamayı Play'de bulamaz. Kahve dükkânı için bu
> kutu işaretsiz bırakıldı.

> 🔗 Kod bağlantısı: 13-17 kitlesi beyan edildiği için `ads_service.dart` içinde
> reklam içerik derecelendirmesi üst sınırı **T (Teen)** olarak ayarlandı
> (`RequestConfiguration(maxAdContentRating: MaxAdContentRating.t)`), böylece
> MA (yetişkin) içerikli reklam gelmez. Hedef kitle ileride değişirse bu ayar da
> gözden geçirilmeli.

---

## 5) Gizlilik politikası
*(Privacy policy)*

URL değişmiyor:
`https://ibrahimyasar68.github.io/coffee_shop_loyalty/privacy-policy-tr.html`

İçeriği 26 Ağustos 2026'da güncellendi ve **yayına alındı**: Bölüm 3 artık AdMob'u,
reklam kimliğini ve kullanıcının kişiselleştirilmiş reklamı kapatma yolunu
açıklıyor. Eski metin "reklam göstermez" diyordu ve reklamlı sürümle çelişirdi.

> Not: Sayfa `main` dalının `docs/` klasöründen yayınlanıyor (gh-pages'ten değil).
> Politikada bir değişiklik gerekirse `docs/privacy-policy-tr.html` düzenlenip
> `main` push edilir; yayın ~1 dakikada geçer.

---

## 6) Yayın stratejisi

1. **Kapalı test** *(Closed testing)* kanalına 1.3.3+9 yükle.
2. Test cihazında doğrula:
   - Ana ekranın altında banner görünüyor mu?
   - 3. siparişten sonra tam ekran reklam geliyor mu?
   - Reklamlar **gerçek** mi? (Test reklamları "Test Ad" etiketi taşır; release
     build'de bu etiket görünmemeli.)
3. Sorun yoksa **Üretim** *(Production)* kanalına **aşamalı kullanıma sunma**
   *(staged rollout)* ile geç: %10 → %50 → %100.
4. **Android açısından önemli bilgiler → Kilitlenmeler ve ANR'ler**
   *(Android vitals → Crashes & ANRs)* ilk 48 saat izlenmeli; reklam SDK'sı
   ilk kez ekleniyor.

---

## 7) Opsiyonel — app-ads.txt

AdMob, sahte envanteri engellemek için `app-ads.txt` önerir. Play kaydındaki
geliştirici web sitesi alan adının **kökünde** yayınlanmalı
(`https://alanadi.com/app-ads.txt`). GitHub Pages proje sayfası
(`/coffee_shop_loyalty/`) kök dizin olmadığı için buna uygun değildir; kendi alan
adın yoksa şimdilik atlanabilir. Gelir üzerinde doğrudan etkisi olmaz, yalnızca
doğrulama sağlar.

---

## 8) AdMob tarafında kapalı kalması gerekenler

- **İş ortağı teklifli sistemi / uyumlulaştırma** *(partner bidding / mediation)* —
  kapalı. Projede hiçbir üçüncü taraf ağ adaptörü yok; açılsa bile talep gelmez ve
  Data safety beyanını genişletmek gerekirdi.
- Sadece **iki reklam birimi** var: Banner ve Geçiş *(Interstitial)*. Ödüllü,
  Ödüllü geçiş, Yerel gelişmiş ve Uygulama açıkken biçimlerinin kodda karşılığı yok.
