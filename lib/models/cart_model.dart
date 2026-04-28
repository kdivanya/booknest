import 'book.dart';

class CartItem {
  final Book book;
  int quantity;

  CartItem({required this.book, this.quantity = 1});

  double get totalPrice => book.price * quantity;
}

class WishlistItem {
  final Book book;
  bool isSelected;

  WishlistItem({required this.book, this.isSelected = false});
}

// Simple in-memory store (no provider needed for this project scope)
class AppStore {
  static final AppStore _instance = AppStore._internal();
  factory AppStore() => _instance;
  AppStore._internal();

  final List<CartItem> cartItems = [];
  final List<WishlistItem> wishlistItems = [];

  void addToCart(Book book) {
    final existing = cartItems.where((c) => c.book.id == book.id).toList();
    if (existing.isNotEmpty) {
      existing.first.quantity++;
    } else {
      cartItems.add(CartItem(book: book));
    }
  }

  void removeFromCart(String bookId) {
    cartItems.removeWhere((c) => c.book.id == bookId);
  }

  void incrementQty(String bookId) {
    final item = cartItems.where((c) => c.book.id == bookId).toList();
    if (item.isNotEmpty) item.first.quantity++;
  }

  void decrementQty(String bookId) {
    final item = cartItems.where((c) => c.book.id == bookId).toList();
    if (item.isNotEmpty) {
      if (item.first.quantity > 1) {
        item.first.quantity--;
      } else {
        removeFromCart(bookId);
      }
    }
  }

  void addToWishlist(Book book) {
    final exists = wishlistItems.any((w) => w.book.id == book.id);
    if (!exists) wishlistItems.add(WishlistItem(book: book));
  }

  void removeFromWishlist(String bookId) {
    wishlistItems.removeWhere((w) => w.book.id == bookId);
  }

  bool isInWishlist(String bookId) {
    return wishlistItems.any((w) => w.book.id == bookId);
  }

  bool isInCart(String bookId) {
    return cartItems.any((c) => c.book.id == bookId);
  }

  double get cartTotal =>
      cartItems.fold(0, (sum, item) => sum + item.totalPrice);

  int get cartCount => cartItems.fold(0, (sum, item) => sum + item.quantity);
}