/**
 * Coffee Shop & Loyalty — Geri Bildirim Anketi oluşturucu (Google Apps Script)
 *
 * KULLANIM:
 * 1. https://script.google.com adresine git → "New project / Yeni proje".
 * 2. Editördeki tüm kodu sil, bu dosyanın içeriğini yapıştır.
 * 3. Üstten "Run / Çalıştır" (createFeedbackForm fonksiyonu seçili olsun).
 * 4. İlk çalıştırmada Google yetki ister → izin ver.
 * 5. "Execution log / Yürütme günlüğü"nde formun düzenleme ve yanıt linkleri görünür.
 *
 * Not: Çalıştırınca Google Drive'ında hazır bir Google Form oluşur.
 */
function createFeedbackForm() {
  var form = FormApp.create('Coffee Shop & Loyalty — Test Geri Bildirimi');
  form.setDescription(
    'Uygulamayı denediğin için teşekkürler! Bu kısa anket ~3 dakika sürer ve ' +
    'uygulamayı geliştirmeme doğrudan yardımcı olur.'
  );
  form.setProgressBar(true);

  // ── Bölüm 1: Genel ───────────────────────────────────────────
  form.addTextItem()
    .setTitle('Adın / takma adın (isteğe bağlı)');

  form.addTextItem()
    .setTitle('Hangi telefonu ve Android sürümünü kullanıyorsun?')
    .setHelpText('Örn. Samsung A52, Android 13');

  form.addScaleItem()
    .setTitle('Uygulamayı genel olarak nasıl değerlendirirsin?')
    .setBounds(1, 5)
    .setLabels('Çok kötü', 'Çok iyi')
    .setRequired(true);

  form.addScaleItem()
    .setTitle('Uygulamayı bir arkadaşına önerme olasılığın nedir?')
    .setBounds(1, 10)
    .setLabels('Asla', 'Kesinlikle')
    .setRequired(true);

  // ── Bölüm 2: Kullanım ────────────────────────────────────────
  form.addPageBreakItem().setTitle('Kullanım');

  form.addCheckboxItem()
    .setTitle('Hangi bölümleri denedin?')
    .setChoiceValues([
      'Menü / ürün ekleme',
      'Sepet ve sipariş',
      'Üye kaydı / giriş',
      'Profil ve sipariş geçmişi',
      'Ayarlar (dil/tema)',
      'Kullanma Kılavuzu',
      'Admin paneli'
    ]);

  form.addScaleItem()
    .setTitle('Uygulamayı kullanmak ne kadar kolaydı?')
    .setBounds(1, 5)
    .setLabels('Çok zor', 'Çok kolay')
    .setRequired(true);

  form.addParagraphTextItem()
    .setTitle('Kaybolduğun, anlamadığın ya da zorlandığın bir yer oldu mu? Neresi?');

  // ── Bölüm 3: Sorunlar ────────────────────────────────────────
  form.addPageBreakItem().setTitle('Sorunlar');

  form.addMultipleChoiceItem()
    .setTitle('Herhangi bir çökme, donma veya hata yaşadın mı?')
    .setChoiceValues(['Evet', 'Hayır'])
    .setRequired(true);

  form.addParagraphTextItem()
    .setTitle('Cevabın "Evet" ise: ne yaparken oldu, ne gördün?');

  form.addParagraphTextItem()
    .setTitle('Yazım hatası, bozuk hizalama veya okunmayan metin fark ettin mi? Nerede?');

  // ── Bölüm 4: Tasarım ve öneriler ─────────────────────────────
  form.addPageBreakItem().setTitle('Tasarım ve öneriler');

  form.addScaleItem()
    .setTitle('Tasarımı (renkler, görünüm, animasyonlar) nasıl buldun?')
    .setBounds(1, 5)
    .setLabels('Kötü', 'Çok iyi');

  form.addMultipleChoiceItem()
    .setTitle('Dil (TR/EN) ve tema (Açık/Koyu) seçeneklerini denedin mi, düzgün çalıştı mı?')
    .setChoiceValues([
      'Evet, sorunsuz',
      'Denedim, sorun vardı',
      'Denemedim'
    ]);

  form.addParagraphTextItem()
    .setTitle('Eklenmesini istediğin bir özellik var mı?');

  form.addParagraphTextItem()
    .setTitle('Eklemek istediğin başka herhangi bir görüş / öneri');

  // ── Onay mesajı ──────────────────────────────────────────────
  form.setConfirmationMessage(
    'Geri bildirimin için çok teşekkürler! 🙏 Önerilerine göre güncellemeler ' +
    'yapacağım. Lütfen uygulamayı test süresi boyunca (14 gün) silme ve arada ' +
    'tekrar açmayı unutma. ☕'
  );

  Logger.log('Formu düzenle: ' + form.getEditUrl());
  Logger.log('Testerlara gönderilecek link: ' + form.getPublishedUrl());
}
