import 'book.dart';

class CartItem {
  final Book book;
  int quantity;
  bool isSelected;
  CartItem({required this.book, this.quantity = 1, this.isSelected = true});
  double get total => book.price * quantity;
}

class AppStore {
  static final AppStore _i = AppStore._();
  factory AppStore() => _i;
  AppStore._();

  final List<CartItem> cart = [];
  final Set<String> wishlist = {};
  String currentUser = 'Marceline';
  String currentEmail = 'marcybelle@booknest.com';

  void addToCart(Book book) {
    final idx = cart.indexWhere((c) => c.book.id == book.id);
    if (idx >= 0) { cart[idx].quantity++; } else { cart.add(CartItem(book: book)); }
  }

  void removeFromCart(String id) => cart.removeWhere((c) => c.book.id == id);

  void increment(String id) {
    final idx = cart.indexWhere((c) => c.book.id == id);
    if (idx >= 0) cart[idx].quantity++;
  }

  void decrement(String id) {
    final idx = cart.indexWhere((c) => c.book.id == id);
    if (idx >= 0) {
      if (cart[idx].quantity > 1) { cart[idx].quantity--; } else { cart.removeAt(idx); }
    }
  }

  void clearCart() => cart.clear();

  void toggleWishlist(String id) {
    if (wishlist.contains(id)) { wishlist.remove(id); } else { wishlist.add(id); }
  }

  bool isWishlisted(String id) => wishlist.contains(id);

  double get selectedTotal =>
      cart.where((c) => c.isSelected).fold(0, (sum, c) => sum + c.total);

  int get selectedCount => cart.where((c) => c.isSelected).length;

  int get cartCount => cart.fold(0, (sum, c) => sum + c.quantity);
}