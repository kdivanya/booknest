import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/book.dart';
import '../widgets/book_card.dart';
import '../widgets/genre_section.dart';
import 'detail_book_page.dart';

// STATEFUL WIDGET — HomePage punya search controller & query state
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Book> get _searchResults {
    if (_searchQuery.isEmpty) return [];
    final q = _searchQuery.toLowerCase();
    final all = [
      ...DummyBooks.trending,
      ...DummyBooks.recommended,
      ...DummyBooks.byGenre.values.expand((b) => b),
    ];
    final seen = <String>{};
    return all.where((b) {
      if (seen.contains(b.id)) return false;
      seen.add(b.id);
      return b.title.toLowerCase().contains(q) || b.author.toLowerCase().contains(q);
    }).toList();
  }

  void _openDetail(Book book) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetailBookPage(book: book)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgMain,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header + Search bar ──
            Container(
              color: AppColors.bgPurpleLight,
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Good Morning! 🌸',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'What will you read today?',
                    style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 12),
                  // Search bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.borderMid),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (v) => setState(() => _searchQuery = v),
                      style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
                      decoration: const InputDecoration(
                        hintText: 'Search books, authors...',
                        hintStyle: TextStyle(fontSize: 14, color: AppColors.textHint),
                        prefixIcon: Icon(Icons.search_rounded, color: AppColors.textMuted, size: 20),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Body ──
            Expanded(
              child: _searchQuery.isNotEmpty
                  ? _buildSearchResults()
                  : _buildHomeContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    final results = _searchResults;
    if (results.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🔍', style: TextStyle(fontSize: 48)),
            SizedBox(height: 12),
            Text('No books found', style: TextStyle(color: AppColors.textMuted, fontSize: 15)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final book = results[index];
        return GestureDetector(
          onTap: () => _openDetail(book),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.coverColors[book.coverColorIndex % AppColors.coverColors.length],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(child: Text(book.coverEmoji, style: const TextStyle(fontSize: 24))),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(book.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                      Text(book.author, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, size: 12, color: AppColors.star),
                          Text(' ${book.rating}', style: const TextStyle(fontSize: 11, color: AppColors.star)),
                          const SizedBox(width: 8),
                          Text('Rp ${_fmt(book.price)}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.primaryDark)),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Trending Now ──
          _sectionHeader('Trending Now 🔥'),
          SizedBox(
            height: 185,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: DummyBooks.trending.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, i) => BookCard(
                book: DummyBooks.trending[i],
                onTap: () => _openDetail(DummyBooks.trending[i]),
              ),
            ),
          ),

          // ── Book Recommendation ──
          _sectionHeader('Book Recommendation ✨'),
          SizedBox(
            height: 185,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: DummyBooks.recommended.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, i) => BookCard(
                book: DummyBooks.recommended[i],
                onTap: () => _openDetail(DummyBooks.recommended[i]),
              ),
            ),
          ),

          // ── Genre Sections ──
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Text(
              'Browse by Genre',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.primaryDark),
            ),
          ),
          ...DummyBooks.byGenre.entries.map((entry) => GenreSection(
            genre: entry.key,
            books: entry.value,
            onBookTap: _openDetail,
          )),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.primaryDark,
        ),
      ),
    );
  }

  String _fmt(double price) {
    return '${(price / 1000).toStringAsFixed(0)}.000';
  }
}