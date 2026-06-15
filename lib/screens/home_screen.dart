import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/book.dart';
import '../models/cart_model.dart';
import '../widgets/book_card.dart';
import 'search_screen.dart';
import 'book_detail_screen.dart';
import 'book_list_screen.dart';

// STATEFUL WIDGET — category filter state + wishlist toggle
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _store = AppStore();
  String _selectedCategory = 'Fiction';
  final _categories = [
    'Romance', 'Fantasy', 'Mystery', 'Sci-Fi', 'Horror',
    'Action & Adventure', 'Comic', 'Fiction', 'Non-Fiction',
    'History', 'Self-Help',
  ];

  List<Book> get _recommendedBooks => allBooks.take(6).toList();
  List<Book> get _popularBooks => allBooks.toList();

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

  // FIX: "More" button now opens BookListScreen (grid of books), not SearchScreen
  void _showAllBooks(String title, List<Book> books) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BookListScreen(title: title, books: books),
      ),
    );
  }

  void _showGenreFilter() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          decoration: const BoxDecoration(
            color: AppColors.bg,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Filter by Genre',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark)),
              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _categories.map((cat) {
                  final active = cat == _selectedCategory;
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      setState(() => _selectedCategory = cat);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SearchScreen(initialQuery: cat),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: active ? AppColors.primary : AppColors.bgWhite,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: active ? AppColors.primary : AppColors.border,
                        ),
                      ),
                      child: Text(cat,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: active ? Colors.white : AppColors.textDark,
                          )),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final featuredBooks = allBooks.where((b) => b.isOnSale).toList();
    final screenW = MediaQuery.of(context).size.width;
    final isWide = screenW >= 600;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── App Bar ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    const Icon(Icons.edit_rounded,
                        size: 22, color: AppColors.primary),
                    const SizedBox(width: 8),
                    const Text('BookNest',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark)),
                    const Spacer(),
                    Stack(
                      children: [
                        Container(
                          width: 38, height: 38,
                          decoration: const BoxDecoration(
                              color: AppColors.bgWhite,
                              shape: BoxShape.circle),
                          child: const Icon(Icons.notifications_outlined,
                              size: 20, color: AppColors.textMid),
                        ),
                        Positioned(
                          top: 6, right: 6,
                          child: Container(
                            width: 8, height: 8,
                            decoration: const BoxDecoration(
                                color: AppColors.soldOut,
                                shape: BoxShape.circle),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 38, height: 38,
                      decoration: const BoxDecoration(
                          color: AppColors.primary, shape: BoxShape.circle),
                      child: Center(
                        child: Text(
                          AppStore().currentUser.isNotEmpty
                              ? AppStore()
                                  .currentUser
                                  .substring(0, 2)
                                  .toUpperCase()
                              : 'MB',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Search Bar ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(
                                builder: (_) => SearchScreen())),
                        child: Container(
                          height: 46,
                          decoration: BoxDecoration(
                            color: AppColors.bgWhite,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                  color: AppColors.primaryLighter
                                      .withValues(alpha: 0.2),
                                  blurRadius: 8)
                            ],
                          ),
                          child: const Row(
                            children: [
                              SizedBox(width: 14),
                              Icon(Icons.search_rounded,
                                  color: AppColors.textLight, size: 20),
                              SizedBox(width: 8),
                              Text('Search books',
                                  style: TextStyle(
                                      color: AppColors.textHint,
                                      fontSize: 14)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: _showGenreFilter,
                      child: Container(
                        width: 46, height: 46,
                        decoration: BoxDecoration(
                          color: AppColors.primarySurface,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.tune_rounded,
                            color: AppColors.primary, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── On Sale Today Banner (Responsive) ──
            // Mobile: horizontal scroll dengan card lebar penuh layar - 40px
            // Wide: grid 3 kolom
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 12),
                    child: Text('On Sale Today',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark)),
                  ),
                  if (isWide)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 1.6,
                        ),
                        itemCount:
                            featuredBooks.isNotEmpty ? featuredBooks.length : 1,
                        itemBuilder: (_, i) {
                          final book = featuredBooks.isNotEmpty
                              ? featuredBooks[i]
                              : allBooks[0];
                          return _ResponsiveFeaturedCard(
                              book: book, onTap: () => _openDetail(book));
                        },
                      ),
                    )
                  else
                    // Mobile: card melebar hampir seluruh layar
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount:
                            featuredBooks.isNotEmpty ? featuredBooks.length : 1,
                        itemBuilder: (_, i) {
                          final book = featuredBooks.isNotEmpty
                              ? featuredBooks[i]
                              : allBooks[0];
                          return _ResponsiveFeaturedCard(
                              book: book, onTap: () => _openDetail(book));
                        },
                      ),
                    ),
                ],
              ),
            ),

            // ── You Might Like ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('You Might Like',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark)),
                    TextButton(
                      onPressed: () =>
                          _showAllBooks('You Might Like', _recommendedBooks),
                      child: const Text('More',
                          style: TextStyle(
                              color: AppColors.primary, fontSize: 13)),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: isWide
                    ? GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              (screenW / 160).floor().clamp(2, 6),
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 14,
                          childAspectRatio: 0.62,
                        ),
                        itemCount: _recommendedBooks.length,
                        itemBuilder: (_, i) {
                          final book = _recommendedBooks[i];
                          return BookCard(
                            book: book,
                            onTap: () => _openDetail(book),
                            onWishlist: () => _toggleWishlist(book),
                            wishlisted: _store.isWishlisted(book.id),
                          );
                        },
                      )
                    : SizedBox(
                        height: 220,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.zero,
                          itemCount: _recommendedBooks.length,
                          itemBuilder: (_, i) {
                            final book = _recommendedBooks[i];
                            return Container(
                              width: 140,
                              margin: const EdgeInsets.only(right: 14),
                              child: BookCard(
                                book: book,
                                onTap: () => _openDetail(book),
                                onWishlist: () => _toggleWishlist(book),
                                wishlisted: _store.isWishlisted(book.id),
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ),

            // ── Popular Books ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Popular Books',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark)),
                    TextButton(
                      onPressed: () =>
                          _showAllBooks('Popular Books', _popularBooks),
                      child: const Text('More',
                          style: TextStyle(
                              color: AppColors.primary, fontSize: 13)),
                    ),
                  ],
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (_, i) {
                    final book = _popularBooks[i];
                    return BookCard(
                      book: book,
                      onTap: () => _openDetail(book),
                      onWishlist: () => _toggleWishlist(book),
                      wishlisted: _store.isWishlisted(book.id),
                    );
                  },
                  childCount: _popularBooks.length,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      isWide ? (screenW / 180).floor().clamp(3, 6) : 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.62,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// FIX: Featured card yang responsif — lebarnya mengikuti layar di mobile,
/// bukan hardcoded 280px.
class _ResponsiveFeaturedCard extends StatelessWidget {
  final Book book;
  final VoidCallback onTap;
  const _ResponsiveFeaturedCard(
      {required this.book, required this.onTap});

  String _fmt(double p) => p.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final isWide = screenW >= 600;
    // Mobile: card lebar = layar - 40px (padding kiri kanan) - 12px (gap next card)
    final cardWidth = isWide ? double.infinity : screenW - 40 - 12;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isWide ? null : cardWidth,
        margin: isWide ? EdgeInsets.zero : const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF7C5CBF), Color(0xFF5A3E99)],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Text info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (book.isOnSale)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text('ON SALE TODAY!',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600)),
                    ),
                  const SizedBox(height: 8),
                  Text(book.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          height: 1.2)),
                  const SizedBox(height: 4),
                  Text(book.author,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.75),
                          fontSize: 12)),
                  const SizedBox(height: 10),
                  Text('Rp ${_fmt(book.price)}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  if (book.originalPrice != null &&
                      book.originalPrice! > book.price) ...[
                    const SizedBox(height: 2),
                    Text('Rp ${_fmt(book.originalPrice!)}',
                        style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 12,
                            decoration: TextDecoration.lineThrough)),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Cover image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 80, height: 110,
                color: Colors.white.withValues(alpha: 0.15),
                child: Image.network(
                  book.coverUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.menu_book_rounded,
                    size: 40,
                    color: Colors.white54,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
