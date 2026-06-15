import 'package:flutter/foundation.dart';
import 'book.dart';

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

  String currentUser = 'Marceline';
  String currentEmail = 'marcybelle@booknest.com';

  void _notifyCart() {
    cartUpdated.value++;
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

    final order = Order(
      orderId: 'BN-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
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
  }

  void toggleWishlist(String id) {
    final newWishlist = {...wishlist.value};
    if (newWishlist.contains(id)) {
      newWishlist.remove(id);
    } else {
      newWishlist.add(id);
    }
    wishlist.value = newWishlist;
  }

  bool isWishlisted(String id) => wishlist.value.contains(id);

  double get selectedTotal =>
      cart.where((c) => c.isSelected).fold(0, (sum, c) => sum + c.total);

  int get selectedCount => cart.where((c) => c.isSelected).length;

  int get cartCount => cart.fold(0, (sum, c) => sum + c.quantity);

  int get wishlistCount => wishlist.value.length;

  int get orderCount => orders.value.length;
}
