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
  final _categories = ['Fiction', 'Non-fiction', 'Self-help'];

  List<Book> get _filteredBooks => allBooks
      .where((b) => b.genre.toLowerCase() == _selectedCategory.toLowerCase())
      .toList();

  List<Book> get _popularBooks => allBooks.take(4).toList();

  void _openDetail(Book book) {
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => BookDetailScreen(book: book)));
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
                    const Icon(Icons.edit_rounded, size: 22, color: AppColors.primary),
                    const SizedBox(width: 8),
                    const Text('BookNest',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                    const Spacer(),
                    Stack(
                      children: [
                        Container(
                          width: 38, height: 38,
                          decoration: const BoxDecoration(color: AppColors.bgWhite, shape: BoxShape.circle),
                          child: const Icon(Icons.notifications_outlined, size: 20, color: AppColors.textMid),
                        ),
                        Positioned(
                          top: 6, right: 6,
                          child: Container(
                            width: 8, height: 8,
                            decoration: const BoxDecoration(color: AppColors.soldOut, shape: BoxShape.circle),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 38, height: 38,
                      decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                      child: const Center(
                        child: Text('MB', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
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
                            MaterialPageRoute(builder: (_) => const SearchScreen())),
                        child: Container(
                          height: 46,
                          decoration: BoxDecoration(
                            color: AppColors.bgWhite,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [BoxShadow(color: AppColors.primaryLighter.withValues(alpha: 0.2), blurRadius: 8)],
                          ),
                          child: const Row(
                            children: [
                              SizedBox(width: 14),
                              Icon(Icons.search_rounded, color: AppColors.textLight, size: 20),
                              SizedBox(width: 8),
                              Text('Search books', style: TextStyle(color: AppColors.textHint, fontSize: 14)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 46, height: 46,
                      decoration: BoxDecoration(
                        color: AppColors.primarySurface,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.tune_rounded, color: AppColors.primary, size: 20),
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
                  height: 180,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: featuredBooks.isNotEmpty ? featuredBooks.length : 1,
                    itemBuilder: (_, i) {
                      final book = featuredBooks.isNotEmpty ? featuredBooks[i] : allBooks[0];
                      return FeaturedBookCard(book: book, onTap: () => _openDetail(book));
                    },
                  ),
                ),
              ),
            ),

            // ── Categories ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Categories',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                    const SizedBox(height: 12),
                    Row(
                      children: _categories.map((cat) {
                        final active = cat == _selectedCategory;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedCategory = cat),
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                            decoration: BoxDecoration(
                              color: active ? AppColors.primary : AppColors.bgWhite,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: active ? AppColors.primary : AppColors.border),
                            ),
                            child: Text(cat,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: active ? Colors.white : AppColors.textMid,
                                )),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),

            // ── You Might Like ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('You Might Like',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                    TextButton(
                      onPressed: () {},
                      child: const Text('More', style: TextStyle(color: AppColors.primary, fontSize: 13)),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _filteredBooks.length,
                  itemBuilder: (_, i) {
                    final book = _filteredBooks[i];
                    return Container(
                      width: 140,
                      margin: const EdgeInsets.only(right: 14),
                      child: BookCard(
                        book: book,
                        onTap: () => _openDetail(book),
                        onWishlist: () => setState(() => _store.toggleWishlist(book.id)),
                        wishlisted: _store.isWishlisted(book.id),
                      ),
                    );
                  },
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
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                    TextButton(
                      onPressed: () {},
                      child: const Text('More', style: TextStyle(color: AppColors.primary, fontSize: 13)),
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
                      onWishlist: () => setState(() => _store.toggleWishlist(book.id)),
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
