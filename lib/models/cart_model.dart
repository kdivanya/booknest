import 'package:flutter/foundation.dart';
import 'book.dart';
import '../services/firebase_service.dart';

class CartItem {
  final Book book;
  int quantity;
  bool isSelected;
  CartItem({required this.book, this.quantity = 1, this.isSelected = true});
  double get total => book.price * quantity;
}

class Order {
  final String orderId;
  final DateTime date;
  final String status;
  final List<CartItem> items;
  final double total;
  final String address;
  final String paymentMethod;

  Order({
    required this.orderId,
    required this.date,
    required this.status,
    required this.items,
    required this.total,
    required this.address,
    required this.paymentMethod,
  });

  String get mainBookTitle => items.isNotEmpty ? items.first.book.title : '-';
  int get itemCount => items.fold(0, (sum, c) => sum + c.quantity);

  String get formattedDate {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

class AppStore {
  static final AppStore _i = AppStore._();
  factory AppStore() => _i;
  AppStore._();

  final List<CartItem> cart = [];
  final ValueNotifier<int> cartUpdated = ValueNotifier(0);
  final ValueNotifier<Set<String>> wishlist = ValueNotifier({});
  final ValueNotifier<List<Order>> orders = ValueNotifier([]);

  // Store wishlist data dengan book details untuk Firebase
  final Map<String, Map<String, dynamic>> _wishlistData = {};

  String currentUser = 'Marceline';
  String currentEmail = 'marcybelle@booknest.com';
  String? currentUid; // Firebase UID untuk menyimpan data user

  void _notifyCart() {
    cartUpdated.value++;
    _saveCartToFirebase();
  }

  void addToCart(Book book) {
    final idx = cart.indexWhere((c) => c.book.id == book.id);
    if (idx >= 0) {
      cart[idx].quantity++;
    } else {
      cart.add(CartItem(book: book));
    }
    _notifyCart();
  }

  void removeFromCart(String id) {
    cart.removeWhere((c) => c.book.id == id);
    _notifyCart();
  }

  void increment(String id) {
    final idx = cart.indexWhere((c) => c.book.id == id);
    if (idx >= 0) {
      cart[idx].quantity++;
      _notifyCart();
    }
  }

  void decrement(String id) {
    final idx = cart.indexWhere((c) => c.book.id == id);
    if (idx >= 0) {
      if (cart[idx].quantity > 1) {
        cart[idx].quantity--;
      } else {
        cart.removeAt(idx);
      }
      _notifyCart();
    }
  }

  void clearCart() {
    cart.clear();
    _notifyCart();
  }

  void placeOrder({required String address, required String paymentMethod}) {
    final selected = cart.where((c) => c.isSelected).toList();
    if (selected.isEmpty) return;

    final orderId = 'BN-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    final order = Order(
      orderId: orderId,
      date: DateTime.now(),
      status: 'Completed',
      items: selected.map((c) => CartItem(book: c.book, quantity: c.quantity)).toList(),
      total: selectedTotal,
      address: address,
      paymentMethod: paymentMethod,
    );

    cart.removeWhere((c) => c.isSelected);
    _notifyCart();

    final updated = [...orders.value, order];
    orders.value = updated;

    // Simpan ke Firebase jika user sudah login
    if (currentUid != null) {
      final orderData = {
        'orderId': order.orderId,
        'date': order.date.toIso8601String(),
        'status': order.status,
        'total': order.total,
        'address': order.address,
        'paymentMethod': order.paymentMethod,
        'items': order.items.map((item) => {
          'bookId': item.book.id,
          'bookTitle': item.book.title,
          'bookPrice': item.book.price,
          'quantity': item.quantity,
        }).toList(),
      };
      FirebaseService.instance.saveOrder(currentUid!, orderId, orderData).catchError((e) {
        print('Error saving order: $e');
      });
    }
  }

  /// Toggle wishlist dan simpan dengan book details ke Firebase
  void toggleWishlist(String id, {String title = '', String author = '', double price = 0}) {
    final newWishlist = {...wishlist.value};
    
    if (newWishlist.contains(id)) {
      newWishlist.remove(id);
      _wishlistData.remove(id);
    } else {
      newWishlist.add(id);
      // Simpan detail buku
      _wishlistData[id] = {
        'bookId': id,
        'bookTitle': title,
        'bookAuthor': author,
        'bookPrice': price,
      };
    }
    wishlist.value = newWishlist;

    // Simpan ke Firebase jika user sudah login
    if (currentUid != null) {
      FirebaseService.instance.saveWishlist(currentUid!, _wishlistData).catchError((e) {
        print('Error saving wishlist: $e');
      });
    }
  }

  bool isWishlisted(String id) => wishlist.value.contains(id);

  /// Load wishlist dari Firebase
  void setWishlistFromDb(Map<String, Map<String, dynamic>> wishlistData) {
    final ids = <String>{};
    wishlistData.forEach((key, value) {
      ids.add(key);
      _wishlistData[key] = value;
    });
    wishlist.value = ids;
  }

  double get selectedTotal =>
      cart.where((c) => c.isSelected).fold(0, (sum, c) => sum + c.total);

  int get selectedCount => cart.where((c) => c.isSelected).length;

  int get cartCount => cart.fold(0, (sum, c) => sum + c.quantity);

  int get wishlistCount => wishlist.value.length;

  int get orderCount => orders.value.length;

  /// Clear session data on logout
  void clearSession() {
    currentUid = null;
    currentUser = '';
    currentEmail = '';
    cart.clear();
    _wishlistData.clear();
    wishlist.value = {};
    orders.value = [];
    _notifyCart();
  }

  /// Public read-only view of wishlist details loaded from Firebase
  Map<String, Map<String, dynamic>> get wishlistData => Map.unmodifiable(_wishlistData);

  /// Load orders dari Firebase
  void setOrdersFromDb(List<Map<String, dynamic>> orderDataList) {
    final orderList = <Order>[];
    for (final data in orderDataList) {
      try {
        final orderId = data['orderId'] as String? ?? '';
        final dateStr = data['date'] as String? ?? DateTime.now().toIso8601String();
        final date = DateTime.tryParse(dateStr) ?? DateTime.now();
        final status = data['status'] as String? ?? 'Pending';
        final total = (data['total'] is num) ? (data['total'] as num).toDouble() : 0.0;
        final address = data['address'] as String? ?? '';
        final paymentMethod = data['paymentMethod'] as String? ?? '';

        // Reconstruct cart items dari order data
        final items = <CartItem>[];
        if (data['items'] is List) {
          for (final itemData in data['items'] as List) {
            if (itemData is Map) {
              final bookId = itemData['bookId'] as String? ?? '';
              final bookTitle = itemData['bookTitle'] as String? ?? '';
              final bookPrice = (itemData['bookPrice'] is num) ? (itemData['bookPrice'] as num).toDouble() : 0.0;
              final quantity = itemData['quantity'] is num ? (itemData['quantity'] as num).toInt() : 1;

              // Coba cari buku dari allBooks; jika tidak ketemu, buat book temporary
              final idx = allBooks.indexWhere((b) => b.id == bookId);
              final book = idx != -1 ? allBooks[idx] : Book(
                id: bookId,
                title: bookTitle,
                author: 'Unknown',
                genre: 'General',
                price: bookPrice,
                rating: 0,
                reviewCount: 0,
                synopsis: '',
                coverUrl: '',
              );
              items.add(CartItem(book: book, quantity: quantity, isSelected: true));
            }
          }
        }

        if (orderId.isNotEmpty) {
          final order = Order(
            orderId: orderId,
            date: date,
            status: status,
            items: items,
            total: total,
            address: address,
            paymentMethod: paymentMethod,
          );
          orderList.add(order);
        }
      } catch (e) {
        print('[DEBUG] Error reconstructing order: $e');
      }
    }
    orders.value = orderList;
  }

  void _saveCartToFirebase() {
    if (currentUid == null) return;
    final cartData = <String, dynamic>{};
    for (final item in cart) {
      cartData[item.book.id] = {
        'bookId': item.book.id,
        'bookTitle': item.book.title,
        'bookAuthor': item.book.author,
        'bookPrice': item.book.price,
        'coverUrl': item.book.coverUrl,
        'quantity': item.quantity,
      };
    }
    FirebaseService.instance.saveCart(currentUid!, cartData).catchError((e) {
      print('Error saving cart: $e');
    });
  }

  void setCartFromDb(Map<String, dynamic> cartData) {
    cart.clear();
    cartData.forEach((bookId, value) {
      if (value is Map) {
        final data = Map<String, dynamic>.from(value);
        final quantity = data['quantity'] is num ? (data['quantity'] as num).toInt() : 1;
        final bookPrice = (data['bookPrice'] is num) ? (data['bookPrice'] as num).toDouble() : 0.0;
        final bookTitle = data['bookTitle'] as String? ?? '';
        final bookAuthor = data['bookAuthor'] as String? ?? '';
        final coverUrl = data['coverUrl'] as String? ?? '';

        final idx = allBooks.indexWhere((b) => b.id == bookId);
        final book = idx != -1 ? allBooks[idx] : Book(
          id: bookId,
          title: bookTitle,
          author: bookAuthor,
          genre: 'General',
          price: bookPrice,
          rating: 0,
          reviewCount: 0,
          synopsis: '',
          coverUrl: coverUrl,
        );
        cart.add(CartItem(book: book, quantity: quantity, isSelected: true));
      }
    });
    _notifyCart();
  }
}
