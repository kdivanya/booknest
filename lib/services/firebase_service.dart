import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  FirebaseService._();
  static final FirebaseService instance = FirebaseService._();

  Future<void> init() async {
    await Firebase.initializeApp();
  }

  FirebaseAuth get _auth => FirebaseAuth.instance;
  DatabaseReference get _db => FirebaseDatabase.instance.ref();

  Future<UserCredential> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final uid = cred.user?.uid;
    if (uid != null) {
      await saveUserProfile(uid: uid, name: name, email: email);
    }
    return cred;
  }

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return cred;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> saveUserProfile({
    required String uid,
    required String name,
    required String email,
  }) async {
    final ref = _db.child('users').child(uid);
    await ref.set({
      'name': name,
      'email': email,
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    final snap = await _db.child('users').child(uid).get();
    if (!snap.exists) return null;
    final val = snap.value;
    if (val is Map) {
      return Map<String, dynamic>.from(val as Map);
    }
    return null;
  }

  // Helpers for cart/wishlist/orders — simple writers. The app can call these when
  // local state changes to persist them under `/user_data/{uid}/{collection}`.
  Future<void> writeUserData(String uid, String collection, Map<String, dynamic> data) async {
    final ref = _db.child('user_data').child(uid).child(collection).push();
    await ref.set(data);
  }

  Future<void> setUserObject(String uid, String path, Map<String, dynamic> data) async {
    final ref = _db.child('user_data').child(uid).child(path);
    await ref.set(data);
  }

  // Wishlist — save as Map with book details (bookId -> {title, author, price, etc})
  Future<void> saveWishlist(String uid, Map<String, Map<String, dynamic>> wishlistData) async {
    final ref = _db.child('user_data').child(uid).child('wishlist');
    if (wishlistData.isEmpty) {
      await ref.remove();
    } else {
      await ref.set(wishlistData);
    }
  }

  // Orders — save all orders under /user_data/{uid}/orders
  Future<void> saveOrder(String uid, String orderId, Map<String, dynamic> orderData) async {
    final ref = _db.child('user_data').child(uid).child('orders').child(orderId);
    await ref.set(orderData);
  }

  // Get wishlist with book details
  Future<Map<String, Map<String, dynamic>>> getWishlist(String uid) async {
    print('[DEBUG] FirebaseService.getWishlist: uid=$uid');
    final snap = await _db.child('user_data').child(uid).child('wishlist').get();
    print('[DEBUG] getWishlist snapshot exists=${snap.exists} value=${snap.value}');
    if (!snap.exists) return {};
    final val = snap.value;

    final result = <String, Map<String, dynamic>>{};

    // New format: { bookId: { ...details } }
    if (val is Map) {
      (val as Map).forEach((key, value) {
        if (value is Map) {
          result[key.toString()] = Map<String, dynamic>.from(value as Map);
        } else if (value is String) {
          // older format: { '0': 'book-1', '1': 'book-2' }
          final bookId = value as String;
          result[bookId] = {'bookId': bookId};
        } else if (value == null || value is bool || value is num) {
          // older/alternate format: { '1': true } or { '1': null }
          final bookId = key.toString();
          result[bookId] = {'bookId': bookId};
        }
        // other unexpected types are ignored
      });
      print('[DEBUG] getWishlist normalized keys=${result.keys.toList()}');
      return result;
    }

    // Older/current format: list of bookIds or objects
    // [null, {bookId: 1, bookTitle: ...}, {bookId: 2, ...}] or ['book-1', 'book-2']
    if (val is List) {
      for (final item in val) {
        if (item == null) {
          // skip nulls
          continue;
        } else if (item is Map) {
          // item is {bookId: 1, bookTitle: ..., bookAuthor: ..., bookPrice: ...}
          final itemMap = Map<String, dynamic>.from(item as Map);
          final bookId = itemMap['bookId']?.toString() ?? '';
          if (bookId.isNotEmpty) {
            result[bookId] = itemMap;
          }
        } else if (item is String) {
          // older format: just bookId string
          result[item] = {'bookId': item};
        }
        // other types ignored
      }
      print('[DEBUG] getWishlist normalized keys=${result.keys.toList()} (from List)');
      return result;
    }

    print('[DEBUG] getWishlist returned empty (unexpected type)');
    return result;
  }

  // Cart — save as Map with bookId -> {bookId, title, price, coverUrl, quantity}
  Future<void> saveCart(String uid, Map<String, dynamic> cartData) async {
    final ref = _db.child('user_data').child(uid).child('cart');
    if (cartData.isEmpty) {
      await ref.remove();
    } else {
      await ref.set(cartData);
    }
  }

  Future<Map<String, dynamic>> getCart(String uid) async {
    final snap = await _db.child('user_data').child(uid).child('cart').get();
    if (!snap.exists || snap.value == null) return {};
    final val = snap.value;
    if (val is Map) {
      return Map<String, dynamic>.from(val);
    }
    return {};
  }

  // Get all orders — handle both Map and List formats
  Future<List<Map<String, dynamic>>> getOrders(String uid) async {
    print('[DEBUG] FirebaseService.getOrders: uid=$uid');
    final snap = await _db.child('user_data').child(uid).child('orders').get();
    print('[DEBUG] getOrders snapshot exists=${snap.exists} value=${snap.value}');
    if (!snap.exists) return [];
    final val = snap.value;
    final result = <Map<String, dynamic>>[];

    // New format: { orderId: { ...orderData } }
    if (val is Map) {
      (val as Map).forEach((key, value) {
        if (value is Map) {
          result.add(Map<String, dynamic>.from(value as Map));
        }
      });
      print('[DEBUG] getOrders found ${result.length} orders from Map');
      return result;
    }

    // Older format: [null, {...}, {...}] or other List
    if (val is List) {
      for (final item in val) {
        if (item == null) {
          continue;
        } else if (item is Map) {
          result.add(Map<String, dynamic>.from(item as Map));
        }
      }
      print('[DEBUG] getOrders found ${result.length} orders from List');
      return result;
    }

    print('[DEBUG] getOrders returned empty (unexpected type)');
    return result;
  }
}
