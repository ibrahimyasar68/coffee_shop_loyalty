# Play Console — Reklam Sonrası Beyan Kılavuzu (1.3.3+9)

AdMob entegrasyonundan sonra Play Console'da güncellenmesi gereken beyanlar.
Form doldururken bu dosyayı yanında açık tut. Sıra önemli: **beyanları AAB
yüklemeden önce** tamamlarsan sürüm incelemesi tek turda biter.

> Play Console'u **Türkçe** kullanıyorsan menü adlarının Türkçe karşılıklarıyla
> hazırlanmış sürüm: [`play-data-safety-reklam-tr.md`](play-data-safety-reklam-tr.md)

---

## 1) App content → Ads

| Soru | Cevap |
|---|---|
| Does your app contain ads? | **Yes** |

> Sonuç: Mağaza girişinde **"Contains ads"** rozeti görünür. Bu, kullanıcıya
> gösterilen kalıcı bir etikettir; reklam kaldırılmadan geri alınamaz.

---

## 2) App content → Advertising ID

| Soru | Cevap |
|---|---|
| Does your app use advertising ID? | **Yes** |
| Kullanım amacı (birden fazla seçilebilir) | **Advertising or marketing** |
| Diğer amaçlar (Analytics, Fraud prevention…) | **İşaretleme** — uygulamada analitik yok |

> Gerekçe: `AndroidManifest.xml` içinde `com.google.android.gms.permission.AD_ID`
> izni bildirildi ve google_mobile_ads bu kimliği kullanıyor. Beyan edilmezse
> sürüm reddedilir.

---

## 3) App content → Data safety

Bu bölüm 1.3.2'de **"No data collected"** olarak beyan edilmişti. Reklamla
birlikte bu artık **doğru değil** — mutlaka güncellenmeli.

### 3a. Genel sorular

| Soru | Cevap |
|---|---|
| Does your app collect or share any of the required user data types? | **Yes** |
| Is all of the user data collected by your app encrypted in transit? | **Yes** (AdMob istekleri HTTPS) |
| Do you provide a way for users to request that their data is deleted? | **No** — veri cihazda tutulur, uygulama kaldırılınca silinir. Açıklama alanına bu not yazılabilir. |

### 3b. Veri türleri — SADECE şu tek kalem işaretlenecek

**Device or other IDs → Device or other IDs**

| Alan | Cevap |
|---|---|
| Collected | **Yes** |
| Shared | **Yes** (Google/AdMob ile paylaşılıyor) |
| Processed ephemerally | **No** |
| Required or optional | **Data collection is required** (kullanıcı reddedemiyor) |
| Purposes | **Advertising or marketing** |

### 3c. İşaretlenMEyecekler (yanlışlıkla seçilmesin)

Aşağıdaki veriler cihazdan hiç çıkmıyor — Hive'da yerel saklanıyor. Play'in
tanımına göre **"collected" sayılmaz**, çünkü ağ üzerinden hiçbir yere iletilmiyor:

- Personal info → Name, Phone number  (yerel üyelik kaydı)
- Photos and videos  (yalnızca URL referansı)
- App activity → Purchase history  (sipariş geçmişi yerel)
- Location, Contacts, Messages, Financial info → hiçbiri yok

> Not: Play, "collected" tanımını **cihazdan sunucuya aktarım** üzerinden yapar.
> Yalnızca cihazda kalan veri beyan edilmez. Emin olmak istersen form içindeki
> "Learn more" bağlantısındaki tanımı okuyup kararı kendin ver.

---

## 4) App content → Target audience and content

| Soru | Cevap |
|---|---|
| Hedef yaş grubu | **13-15 + 16-17 + 18 yaş ve üstü** (seçilen: 13+) |
| "Küçük olduğu belirlenen kullanıcıların erişimini kısıtla" | **İşaretsiz** — işaretlenirse 18 altı yaş grupları seçilemez |

> ⚠️ Eğer yaş grubuna 13 altı dahil edilirse Google Play **Families** politikası
> devreye girer; bu durumda kullandığımız standart AdMob birimleri uygun olmaz,
> sertifikalı reklam ağı + `setTagForChildDirectedTreatment` gerekir. Kahve
> dükkânı uygulaması için 13+ doğru cevaptır.

> 🔗 Kod bağlantısı: 13-17 kitlesi beyan edildiği için `ads_service.dart` içinde
> reklam içerik derecelendirmesi üst sınırı **T (Teen)** olarak ayarlandı
> (`RequestConfiguration(maxAdContentRating: MaxAdContentRating.t)`). Hedef kitle
> ileride değişirse bu ayar da gözden geçirilmeli.

---

## 5) Privacy policy

URL değişmiyor:
`https://ibrahimyasar68.github.io/coffee_shop_loyalty/privacy-policy-tr.html`

Ancak **içeriği güncellendi** (26 Ağustos 2026): Bölüm 3 artık AdMob'u, reklam
kimliğini ve kullanıcının kişiselleştirilmiş reklamı kapatma yolunu açıklıyor.
Yeni halin `gh-pages` dalında yayında olduğunu tarayıcıdan doğrula — eski metin
"reklam göstermez" diyordu ve reklamlı sürümle çelişirdi.

---

## 6) Yayın stratejisi

1. **Closed testing** track'ine 1.3.3+9 yükle.
2. Test cihazında doğrula:
   - Ana ekranın altında banner görünüyor mu?
   - 3. siparişten sonra tam ekran reklam geliyor mu?
   - Reklamlar **gerçek** mi (test reklamı "Test Ad" etiketi taşır — release
     build'de bu etiket görünmemeli)
3. Sorun yoksa üretime **kademeli yayın %10 → %50 → %100** ile geç.
4. Play Console → **Vitals → Crashes & ANRs** ilk 48 saat izlenmeli; reklam SDK'sı
   ilk kez ekleniyor.

---

## 7) Opsiyonel — app-ads.txt

AdMob, sahte envanteri engellemek için `app-ads.txt` önerir. Play kaydındaki
geliştirici web sitesi alan adının **kökünde** yayınlanmalı
(`https://alanadi.com/app-ads.txt`). GitHub Pages proje sayfası (`/coffee_shop_loyalty/`)
kök dizin olmadığı için buna uygun değildir; kendi alan adın yoksa şimdilik
atlanabilir. Gelir üzerinde doğrudan etkisi olmaz, sadece doğrulama sağlar.
