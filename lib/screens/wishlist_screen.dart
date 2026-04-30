import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/book.dart';
import '../models/cart_model.dart';
import 'book_detail_screen.dart';

// STATEFUL WIDGET
class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});
  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final _store = AppStore();

  List<Book> get _wishlistBooks =>
      allBooks.where((b) => _store.isWishlisted(b.id)).toList();

  @override
  Widget build(BuildContext context) {
    final books = _wishlistBooks;
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Text('My Wishlist',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            ),
            Expanded(
              child: books.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.favorite_border_rounded, size: 64, color: AppColors.primaryLighter),
                          SizedBox(height: 14),
                          Text('No books in wishlist',
                              style: TextStyle(fontSize: 16, color: AppColors.textMid, fontWeight: FontWeight.w500)),
                          SizedBox(height: 6),
                          Text('Tap ♡ on any book to save it here',
                              style: TextStyle(fontSize: 13, color: AppColors.textHint)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: books.length,
                      itemBuilder: (_, i) {
                        final book = books[i];
                        return GestureDetector(
                          onTap: () => Navigator.push(context,
                              MaterialPageRoute(builder: (_) => BookDetailScreen(book: book))),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.bgWhite,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 56, height: 72,
                                  decoration: BoxDecoration(
                                    color: AppColors.primarySurface,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Center(child: Icon(Icons.menu_book_rounded, size: 28, color: AppColors.primaryLighter)),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(book.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                                      Text(book.author, style: const TextStyle(fontSize: 12, color: AppColors.textLight)),
                                      const SizedBox(height: 6),
                                      Text('Rp ${_fmt(book.price)}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primary)),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => setState(() => _store.toggleWishlist(book.id)),
                                  child: const Icon(Icons.favorite_rounded, color: Colors.red, size: 22),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  String _fmt(double p) => p.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
}
