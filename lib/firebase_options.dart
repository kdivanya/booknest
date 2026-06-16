import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

/// Konfigurasi Firebase untuk semua platform.
/// TODO: Ganti nilai-nilai di bawah dengan konfigurasi project Firebase Anda.
/// Dapatkan nilai ini dari Firebase Console: https://console.firebase.google.com
///
/// Langkah-langkah:
/// 1. Buka Firebase Console
/// 2. Pilih project "booknest-apb"
/// 3. Untuk setiap platform:
///    - WEB: Project Settings > Your apps > Pilih web app > Copy config
///    - ANDROID: Project Settings > Your apps > Pilih Android > Download google-services.json
///    - iOS: Project Settings > Your apps > Pilih iOS > Download GoogleService-Info.plist
/// 4. Isi nilai-nilai di bawah sesuai konfigurasi Anda

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    // Auto-detect berdasarkan platform
    // Untuk web, kita hardcode konfigurasi web
    return web;
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC56k0xMvkpBnZ1eVBGb3kW3YzXN3PK65o',
    authDomain: 'booknest-apb.firebaseapp.com',
    databaseURL: 'https://booknest-apb-default-rtdb.asia-southeast1.firebasedatabase.app',
    projectId: 'booknest-apb',
    storageBucket: 'booknest-apb.firebasestorage.app',
    messagingSenderId: '818417695824',
    appId: '1:818417695824:web:455b45a439358805602555',
  );

  // Placeholder untuk Android (akan diisi kemudian jika dibutuhkan)
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR_ANDROID_API_KEY',
    appId: '1:818417695824:android:YOUR_APP_ID',
    messagingSenderId: '818417695824',
    projectId: 'booknest-apb',
    databaseURL: 'https://booknest-apb-default-rtdb.firebaseio.com',
  );

  // Placeholder untuk iOS (akan diisi kemudian jika dibutuhkan)
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: '1:818417695824:ios:YOUR_APP_ID',
    messagingSenderId: '818417695824',
    projectId: 'booknest-apb',
    databaseURL: 'https://booknest-apb-default-rtdb.firebaseio.com',
  );
}
