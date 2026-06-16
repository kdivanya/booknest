# Firebase Realtime Database Setup untuk BookNest

## Database Rules

Di Firebase Console, navigasi ke **Realtime Database** → **Rules** dan ganti dengan rules berikut:

```json
{
  "rules": {
    "users": {
      "$uid": {
        ".read": "$uid === auth.uid",
        ".write": "$uid === auth.uid",
        "name": { ".validate": "isString($value)" },
        "email": { ".validate": "isString($value)" },
        "createdAt": { ".validate": "isString($value)" }
      }
    },
    "user_data": {
      "$uid": {
        ".read": "$uid === auth.uid",
        ".write": "$uid === auth.uid",
        "wishlist": {
          ".validate": "isArray($value)"
        },
        "orders": {
          "$orderId": {
            ".validate": "hasChildren(['orderId', 'date', 'status', 'total', 'address', 'paymentMethod', 'items'])",
            "orderId": { ".validate": "isString($value)" },
            "date": { ".validate": "isString($value)" },
            "status": { ".validate": "isString($value)" },
            "total": { ".validate": "isNumber($value)" },
            "address": { ".validate": "isString($value)" },
            "paymentMethod": { ".validate": "isString($value)" },
            "items": { ".validate": "isArray($value)" }
          }
        }
      }
    }
  }
}
```

### Penjelasan Rules:
- **`/users/{uid}`**: Profil pengguna hanya bisa dibaca dan ditulis oleh user yang login (dengan UID yang sama).
- **`/user_data/{uid}/wishlist`**: Wishlist disimpan sebagai array ID buku.
- **`/user_data/{uid}/orders`**: Setiap order disimpan dengan orderId sebagai key, berisi detail order (date, total, items, dll).

## Struktur Database

```
{
  "users": {
    "uid123": {
      "name": "Alyyssa",
      "email": "abcd@gmail.com",
      "createdAt": "2026-06-16T00:28:48.149Z"
    }
  },
  "user_data": {
    "uid123": {
      "wishlist": ["book-1", "book-3", "book-5"],
      "orders": {
        "BN-1629": {
          "orderId": "BN-1629",
          "date": "2026-06-16T12:30:00.000Z",
          "status": "Completed",
          "total": 45.99,
          "address": "123 Main St, City",
          "paymentMethod": "Credit Card",
          "items": [
            {
              "bookId": "book-1",
              "bookTitle": "The Great Gatsby",
              "bookPrice": 12.99,
              "quantity": 2
            }
          ]
        }
      }
    }
  }
}
```

## Testing

Setelah mengatur rules:

1. **Login/Register** → Profil user otomatis disimpan ke `/users/{uid}`
2. **Add to Wishlist** → Wishlist otomatis disimpan ke `/user_data/{uid}/wishlist`
3. **Place Order** → Order otomatis disimpan ke `/user_data/{uid}/orders/{orderId}`

Buka Firebase Console **Realtime Database** → **Data** untuk melihat data real-time saat melakukan aksi di app.

## Debugging

Jika data tidak muncul:
- Periksa browser console (`F12`) untuk error Firebase
- Pastikan user sudah login (check `AppStore().currentUid` tidak null)
- Periksa rules tidak memblokir write operations (gunakan mode `Test` untuk sementara)
- Verifikasi databaseURL di `lib/firebase_options.dart` sesuai project

## Migrasi dari Local Data

Jika ada data lokal lama yang ingin dipindahkan:
- Cart items bisa di-sync ke `/user_data/{uid}/cart` dengan format serupa orders
- Modify AppStore.placeOrder untuk load existing orders dari DB saat init
