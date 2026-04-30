import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/book.dart';
import '../models/cart_model.dart';
import '../widgets/book_card.dart';
import 'book_detail_screen.dart';

// STATEFUL WIDGET — search query, results, recent searches state
class SearchScreen extends StatefulWidget {
  final String initialQuery;
  const SearchScreen({super.key, this.initialQuery = ''});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _store = AppStore();
  final _controller = TextEditingController();
  String _query = '';
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

  @override
  void initState() {
    super.initState();
    _query = widget.initialQuery;
    _controller.text = _query;
  }

  final List<String> _recent = ['Fantasy', 'Self-care', 'Cooking'];
  final _popularCategories = [
    'Fiction',
    'Mystery',
    'Fantasy',
    'Adventure',
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Book> get _results {
    if (_query.isEmpty) return [];
    final q = _query.toLowerCase();
    return allBooks
        .where((b) =>
            b.title.toLowerCase().contains(q) ||
            b.author.toLowerCase().contains(q) ||
            b.genre.toLowerCase().contains(q))
        .toList();
  }

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
                  final active = _query.toLowerCase() == cat.toLowerCase();
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _query = cat;
                        _controller.text = cat;
                      });
                      Navigator.pop(context);
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
    final results = _results;
    final isEmpty = _query.isNotEmpty && results.isEmpty;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            // Search bar row
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_rounded,
                        color: AppColors.textDark, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color: AppColors.bgWhite,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: TextField(
                        controller: _controller,
                        autofocus: true,
                        onChanged: (v) => setState(() => _query = v),
                        style: const TextStyle(
                            fontSize: 14, color: AppColors.textDark),
                        decoration: const InputDecoration(
                          hintText: 'Search books...',
                          hintStyle: TextStyle(
                              color: AppColors.textHint, fontSize: 14),
                          prefixIcon: Icon(Icons.search_rounded,
                              color: AppColors.textLight, size: 20),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 13),
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
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.tune_rounded,
                          color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: _query.isEmpty
                  ? _buildDefault()
                  : isEmpty
                      ? _buildEmpty()
                      : _buildResults(results),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefault() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('RECENT SEARCHES',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textLight,
                      letterSpacing: 0.5)),
              GestureDetector(
                onTap: () => setState(() => _recent.clear()),
                child: const Text('Clear All',
                    style: TextStyle(fontSize: 12, color: AppColors.primary)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _recent
                .map((r) => GestureDetector(
                      onTap: () {
                        setState(() {
                          _query = r;
                          _controller.text = r;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: AppColors.bgWhite,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(r,
                                style: const TextStyle(
                                    fontSize: 13, color: AppColors.textMid)),
                            const SizedBox(width: 6),
                            GestureDetector(
                              onTap: () => setState(() => _recent.remove(r)),
                              child: const Icon(Icons.close_rounded,
                                  size: 14, color: AppColors.textLight),
                            ),
                          ],
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Column(
      children: [
        const Spacer(),
        const Icon(Icons.menu_book_rounded,
            size: 80, color: AppColors.primaryLighter),
        const SizedBox(height: 16),
        const Text('Book Not Found',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark)),
        const SizedBox(height: 8),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            "We couldn't find any results for your search. Try another keywords or check your spelling.",
            textAlign: TextAlign.center,
            style:
                TextStyle(fontSize: 13, color: AppColors.textMid, height: 1.5),
          ),
        ),
        const Spacer(),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Text('POPULAR CATEGORIES',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textLight,
                      letterSpacing: 0.5)),
              SizedBox(height: 12),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: _popularCategories
                .map((c) => GestureDetector(
                      onTap: () {
                        setState(() {
                          _query = c;
                          _controller.text = c;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.bgWhite,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Text(c,
                            style: const TextStyle(
                                fontSize: 13, color: AppColors.textMid)),
                      ),
                    ))
                .toList(),
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildResults(List<Book> results) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Search Results',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark)),
              Text('${results.length} found',
                  style: const TextStyle(
                      fontSize: 13, color: AppColors.textLight)),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 0.62,
            ),
            itemCount: results.length,
            itemBuilder: (_, i) {
              final book = results[i];
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
    );
  }
}
