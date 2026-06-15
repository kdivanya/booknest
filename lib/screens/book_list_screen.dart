import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/book.dart';
import '../models/cart_model.dart';
import '../widgets/book_card.dart';
import 'book_detail_screen.dart';

/// Layar yang muncul saat tombol "More" ditekan.
/// Menampilkan daftar buku dalam grid, bukan search UI.
class BookListScreen extends StatefulWidget {
  final String title;
  final List<Book> books;
  const BookListScreen({super.key, required this.title, required this.books});

  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  final _store = AppStore();

  void _openDetail(Book book) {
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => BookDetailScreen(book: book)));
  }

  void _toggleWishlist(Book book) {
    setState(() => _store.toggleWishlist(book.id));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_store.isWishlisted(book.id)
            ? '"${book.title}" added to wishlist'
            : '"${book.title}" removed from wishlist'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final crossCount = screenW >= 600
        ? (screenW / 180).floor().clamp(3, 6)
        : 2;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 38, height: 38,
                      decoration: BoxDecoration(
                        color: AppColors.bgWhite,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.arrow_back_rounded,
                          size: 18, color: AppColors.textDark),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(widget.title,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark)),
                  const Spacer(),
                  Text('${widget.books.length} books',
                      style: const TextStyle(
                          fontSize: 13, color: AppColors.textLight)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossCount,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.62,
                ),
                itemCount: widget.books.length,
                itemBuilder: (_, i) {
                  final book = widget.books[i];
                  return BookCard(
                    book: book,
                    onTap: () => _openDetail(book),
                    onWishlist: () => _toggleWishlist(book),
                    wishlisted: _store.isWishlisted(book.id),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
