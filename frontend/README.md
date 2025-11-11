
# 📱 Frontend JagaJiwa

Folder ini berisi seluruh *source code* untuk aplikasi mobile JagaJiwa, yang dibangun menggunakan [Flutter](https://flutter.dev/)

## 🚀 Pendahuluan

Panduan ini akan membantu Anda menjalankan salinan proyek ini di mesin lokal Anda untuk tujuan pengembangan dan pengujian.

### Prasyarat 

* **Flutter SDK:** Pastikan Anda telah menginstal Flutter SDK versi stabil terbaru. (Lihat [dokumentasi Flutter](https://flutter.dev/docs/get-started/install)).
* **IDE:** [Visual Studio Code](https://code.visualstudio.com/) (direkomendasikan) atau [Android Studio](https://developer.android.com/studio).
* **Target Device:**
    * (Direkomendasikan) Aplikasi *native* desktop (Windows/macOS/Linux) untuk *hot reload* super cepat.
    * Emulator Android (minimal API 31 - Android 12).
    * Perangkat fisik Android.

### ⚙️ Instalasi dan Konfigurasi

1.  **Clone Repositori:** (Jika Anda belum melakukannya dari *root*)
    ```bash
    git clone https://github.com/Garmandsk/jagajiwa.git
    ```
2.  **Masuk ke Folder Frontend:**
    ```bash
    cd jagajiwa/frontend
    ```
3.  **Install Dependensi:**
    ```bash
    flutter pub get
    ```
4.  **Konfigurasi Environment (SANGAT PENTING):**
    Aplikasi ini perlu terhubung ke Supabase.
    * Buat file baru di `frontend/lib/` bernama `.env`.
    * Isi file tersebut dengan kredensial Supabase Anda (tanyakan pada Project Manager atau lihat di dashboard Supabase):
        ```ini
        SUPABASE_URL=https://<project-id>.supabase.co
        SUPABASE_ANON_KEY=<your-public-anon-key>
        ```
    * *Catatan: Pastikan file `.env` ini sudah ditambahkan ke `.gitignore`!*
    * (Pastikan Anda telah memuat variabel-variabel ini di `main.dart` Anda, biasanya menggunakan *package* `flutter_dotenv`).

### 🏃 Menjalankan Aplikasi

Anda dapat menjalankan aplikasi menggunakan target *device* yang Anda inginkan.

**Untuk Menjalankan di Desktop (Sangat Direkomendasikan untuk Development):**
Pastikan *support* desktop sudah diaktifkan (`flutter config --enable-windows-desktop`, dll.)

```bash
flutter run -d windows
# ATAU
flutter run -d macos
# ATAU
flutter run -d linux
````

**Untuk Menjalankan di Emulator/Perangkat Mobile:**
Pastikan emulator Anda berjalan atau perangkat Anda terhubung.

```bash
flutter run
```

## 🏗️ Arsitektur Folder (`lib`)

Proyek ini menggunakan arsitektur **feature-first** yang bersih untuk memisahkan logika dari UI.

  * **`lib/app/`**: Konfigurasi global (Tema, Rute GoRouter, Widget Kustom Bersama).
  * **`lib/core/`**: Kode pendukung (Model Data, Servis API, Helper/Utils).
  * **`lib/features/`**: Inti aplikasi. Setiap fitur (misal: `9_profile`, `7_community_forum`) memiliki folder sendiri yang berisi `screens`, `providers`, dan `widgets` spesifik untuk fitur tersebut.
  * **`lib/main.dart`**: Titik masuk utama, inisialisasi Supabase, dan registrasi `MultiProvider`.

## 🔄 State Management

  * Proyek ini menggunakan **Provider** untuk *state management*.
  * Semua *provider* didaftarkan secara global di `main.dart` menggunakan `MultiProvider`.
  * Setiap fitur memiliki *provider*-nya sendiri (misal: `ProfileProvider`) yang bertanggung jawab atas *state* fitur Profile.

## 🧭 Navigasi (Routing)

  * Proyek ini menggunakan **GoRouter** untuk navigasi deklaratif.
  * Semua rute aplikasi didefinisikan secara terpusat di `lib/app/routes/app_router.dart`.
  * Untuk pindah halaman, gunakan: `context.go('/nama-rute')`.