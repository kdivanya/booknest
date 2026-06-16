# 📚 BookNest

> Your Cozy Digital Bookstore — aplikasi mobile belanja buku berbasis Flutter & Firebase.

**Mata Kuliah:** Aplikasi Perangkat Bergerak  
**Universitas Telkom Jakarta, 2026**

## Tim

| Nama | NIM | Peran |
|------|-----|-------|
| Kurnia Ramadani | 103062330042 | UI/UX & Halaman Utama |
| Allyssa Humayra | 103062330044 | Autentikasi & Manajemen Akun |
| Kareen Divanya Permadhie | 103062300050 | Fitur Transaksi |
| Aulia Karenovsqhie Pratasik | 103062300059 | Pencarian & Wishlist |

## Fitur

Splash screen, autentikasi (register/login/forgot password), beranda dengan filter genre, pencarian buku, detail buku (synopsis/reviews/details), wishlist, keranjang belanja, checkout, riwayat pesanan, dan manajemen profil.

## Tech Stack

- **Flutter** — cross-platform Android & iOS
- **Firebase Authentication** — login via email/password
- **Firebase Realtime Database** — sinkronisasi data real-time
- **State management** — ValueNotifier + Singleton (`AppStore`)

## Cara Menjalankan

```bash
git clone https://github.com/kur24nia/booknest.git
cd booknest
flutter pub get
flutter run
```

> Untuk konfigurasi Firebase, lihat [`FIREBASE_SETUP.md`](FIREBASE_SETUP.md).
