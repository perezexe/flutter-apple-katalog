Github Linki: https://github.com/perezexe/flutter-apple-katalog/tree/main

# Apple Device Katalog & Shopping App

##  Proje Açıklaması
Bu uygulama, Flutter kullanılarak geliştirilmiş modern bir mobil e-ticaret katalog uygulamasıdır. Uygulama, canlı bir PHP API (`wantapi.com`) üzerinden ürün verilerini (isim, fiyat, görsel, açıklama) anlık olarak çeker. 

**Temel Özellikler:**
*   **Dinamik Veri Çekme:** Ürünler `http` paketi kullanılarak uzaktaki bir sunucudan çekilir.
*   **Arama Fonksiyonu:** Ürünler arasında başlığa göre anlık arama yapılabilir.
*   **Favori Sistemi:** `ValueListenableBuilder` mimarisi kullanılarak ürünler favorilere eklenebilir ve filtrelenebilir.
*   **Sepet Yönetimi:** Ürünler sepete eklenebilir, adetleri güncellenebilir ve toplam tutar otomatik hesaplanır.
*   **Ödeme Simülasyonu:** Sepetteki ürünler için bir ödeme ekranı ve satın alma süreci simüle edilmiştir.

##  Kullanılan Teknolojiler
*   **Framework:** Flutter (Material 3)
*   **Dil:** Dart
*   **Veri Yönetimi:** JSON / REST API
*   **Paketler:** `http`, `dart:convert`
*   **Mimari:** State Management için `ChangeNotifier` ve `ValueNotifier` yaklaşımları kullanılmıştır.

##  Kullanılan Flutter Sürümü
*   **Flutter:** 3.22.0 veya üzeri (Stabil Kanal)
*   **Dart:** 3.4.0 veya üzeri

> *Not: Bilgisayarınızdaki tam sürümü öğrenmek için terminale `flutter --version` yazabilirsiniz.*

##  Çalıştırma Adımları

Projeyi kendi bilgisayarınızda çalıştırmak için aşağıdaki adımları izleyebilirsiniz:

1.  **Projeyi Klonlayın veya İndirin:**
    Dosyaları bilgisayarınıza indirin ve bir klasöre çıkartın.

2.  **Bağımlılıkları Yükleyin:**
    Proje klasörünün içindeyken terminale şu komutu yazarak gerekli paketleri indirin:
    ```bash
    flutter pub get
    ```

3.  **Uygulamayı Çalıştırın:**
    Uygulama, internet üzerinden görsel çektiği için Chrome üzerinde test ederken güvenlik (CORS) engeline takılmaması adına aşağıdaki özel komutla başlatılmalıdır:
    ```bash
    flutter run -d chrome --web-browser-flag "--disable-web-security"
    ```

4.  **Emülatörde Çalıştırmak İçin (Opsiyonel):**
    Eğer Android veya iOS emülatörü kullanacaksanız doğrudan şu komutu kullanabilirsiniz:
    ```bash
    flutter run
    ```
