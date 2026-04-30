import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/book.dart';
import '../models/cart_model.dart';
import '../widgets/book_card.dart';
import 'search_screen.dart';
import 'book_detail_screen.dart';

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
    'Romance',
    'Fantasy',
    'Mystery',
    'Sci-Fi',
    'Horror',
    'Action & Adventure',
    'Comic',
    'Fiction',
    'Non-Fiction',
    'History',
    'Self-Help',
  ];

  List<Book> get _recommendedBooks => allBooks.take(4).toList();

  List<Book> get _popularBooks => allBooks.take(4).toList();

  void _openDetail(Book book) {
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => BookDetailScreen(book: book)));
  }

  void _toggleWishlist(Book book) {
    setState(() {
      _store.toggleWishlist(book.id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_store.isWishlisted(book.id)
            ? '"${book.title}" ditambahkan ke wishlist'
            : '"${book.title}" dihapus dari wishlist'),
        duration: const Duration(seconds: 1),
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
                  width: 40,
                  height: 4,
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
              const SizedBox(height: 8),
              const Text('Pilih genre buku yang ingin ditampilkan.',
                  style: TextStyle(fontSize: 13, color: AppColors.textMid)),
              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _categories.map((cat) {
                  final active = cat == _selectedCategory;
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
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
                          width: 38,
                          height: 38,
                          decoration: const BoxDecoration(
                              color: AppColors.bgWhite, shape: BoxShape.circle),
                          child: const Icon(Icons.notifications_outlined,
                              size: 20, color: AppColors.textMid),
                        ),
                        Positioned(
                          top: 6,
                          right: 6,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                                color: AppColors.soldOut,
                                shape: BoxShape.circle),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 38,
                      height: 38,
                      decoration: const BoxDecoration(
                          color: AppColors.primary, shape: BoxShape.circle),
                      child: const Center(
                        child: Text('MB',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold)),
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
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const SearchScreen())),
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
                                      color: AppColors.textHint, fontSize: 14)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: _showGenreFilter,
                      child: Container(
                        width: 46,
                        height: 46,
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

            // ── Featured Banner ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                child: SizedBox(
                  height: 215,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount:
                        featuredBooks.isNotEmpty ? featuredBooks.length : 1,
                    itemBuilder: (_, i) {
                      final book = featuredBooks.isNotEmpty
                          ? featuredBooks[i]
                          : allBooks[0];
                      return FeaturedBookCard(
                          book: book, onTap: () => _openDetail(book));
                    },
                  ),
                ),
              ),
            ),

            // ── You Might Like ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('You Might Like',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark)),
                    TextButton(
                      onPressed: () {},
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
                child: SizedBox(
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
                      onPressed: () {},
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
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
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
