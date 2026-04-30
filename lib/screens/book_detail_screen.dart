import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/book.dart';
import '../models/cart_model.dart';
import 'cart_screen.dart';

// STATEFUL WIDGET — tab selection, wishlist toggle, read more
class BookDetailScreen extends StatefulWidget {
  final Book book;
  const BookDetailScreen({super.key, required this.book});
  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  final _store = AppStore();
  int _tab = 0; // 0=Synopsis, 1=Reviews, 2=Details
  bool _expanded = false;
  late bool _wishlisted;

  @override
  void initState() {
    super.initState();
    _wishlisted = _store.isWishlisted(widget.book.id);
  }

  void _toggleWishlist() => setState(() {
        _store.toggleWishlist(widget.book.id);
        _wishlisted = _store.isWishlisted(widget.book.id);
      });

  void _buyNow() {
    _store.addToCart(widget.book);
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const CartScreen()));
  }

  void _addToCart() {
    _store.addToCart(widget.book);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Book added to cart'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final book = widget.book;
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // ── Top actions ──
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                      child: Row(
                        children: [
                          _iconBtn(Icons.arrow_back_rounded,
                              () => Navigator.pop(context)),
                          const Spacer(),
                          _iconBtn(Icons.share_outlined, () {}),
                          const SizedBox(width: 10),
                          _iconBtn(
                            _wishlisted
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            _toggleWishlist,
                            color: _wishlisted ? Colors.red : null,
                            bgColor:
                                _wishlisted ? const Color(0xFFFFECEC) : null,
                          ),
                        ],
                      ),
                    ),

                    // ── Book Cover ──
                    Container(
                      margin: const EdgeInsets.all(32),
                      height: 260,
                      decoration: BoxDecoration(
                        color: AppColors.primarySurface,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.15),
                              blurRadius: 20,
                              offset: const Offset(0, 8)),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Center(
                          child: Image.network(
                            book.coverUrl,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.contain,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                color: AppColors.primarySurface,
                                child: const Center(
                                    child: CircularProgressIndicator(strokeWidth: 2)),
                              );
                            },
                            errorBuilder: (_, __, ___) => Container(
                              color: AppColors.primarySurface,
                              child: const Center(
                                child: Icon(Icons.menu_book_rounded,
                                    size: 72, color: AppColors.primaryLighter),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // ── Title & Rating ──
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          Text(book.title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textDark)),
                          const SizedBox(height: 4),
                          Text('by ${book.author}',
                              style: const TextStyle(
                                  fontSize: 13, color: AppColors.textMid)),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ...List.generate(5, (i) {
                                if (i < book.rating.floor()) {
                                  return const Icon(Icons.star_rounded,
                                      size: 18, color: AppColors.star);
                                } else if (i < book.rating) {
                                  return const Icon(Icons.star_half_rounded,
                                      size: 18, color: AppColors.star);
                                }
                                return const Icon(Icons.star_border_rounded,
                                    size: 18, color: AppColors.star);
                              }),
                              const SizedBox(width: 6),
                              Text('(${book.reviewCount} reviews)',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textLight)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text('Rp ${_fmt(book.price)}',
                              style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary)),
                          const SizedBox(height: 16),
                          // Format pills
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _pill('FORMAT', book.format),
                              const SizedBox(width: 10),
                              _pill('PAGES', '${book.pages}'),
                              const SizedBox(width: 10),
                              _pill('LANGUAGE', book.language),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Tab bar
                          Row(
                            children: [
                              _tabBtn('Synopsis', 0),
                              const SizedBox(width: 24),
                              _tabBtn('Reviews', 1),
                              const SizedBox(width: 24),
                              _tabBtn('Details', 2),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Tab content
                          _buildTabContent(book),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Bottom Buttons ──
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              decoration: const BoxDecoration(
                color: AppColors.bgWhite,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _buyNow,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26)),
                      ),
                      child: const Text('Buy Now',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _addToCart,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart_outlined,
                            size: 16, color: AppColors.textMid),
                        SizedBox(width: 6),
                        Text('Add to Cart',
                            style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textMid,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(Book book) {
    switch (_tab) {
      case 0: // Synopsis
        final lines = book.synopsis.split('\n');
        final preview = lines.first;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _expanded ? book.synopsis : preview,
              style: const TextStyle(
                  fontSize: 14, color: AppColors.textDark, height: 1.6),
            ),
            if (!_expanded && lines.length > 1) ...[
              const SizedBox(height: 4),
              Text(
                lines.length > 1 ? lines.last : '',
                style: const TextStyle(
                    fontSize: 14, color: AppColors.textLight, height: 1.6),
              ),
            ],
            const SizedBox(height: 6),
            GestureDetector(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Text(
                _expanded ? 'Show less...' : 'Read more...',
                style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        );

      case 1: // Reviews
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rating summary
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${book.rating}',
                        style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark)),
                    Row(
                        children: List.generate(
                            5,
                            (i) => Icon(
                                i < book.rating.floor()
                                    ? Icons.star_rounded
                                    : Icons.star_border_rounded,
                                size: 14,
                                color: AppColors.star))),
                    const SizedBox(height: 2),
                    Text('${book.reviewCount} TOTAL',
                        style: const TextStyle(
                            fontSize: 10, color: AppColors.textLight)),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    children: [5, 4, 3, 2, 1].map((star) {
                      final pct = star == 5
                          ? 0.7
                          : star == 4
                              ? 0.4
                              : star == 3
                                  ? 0.08
                                  : star == 2
                                      ? 0.04
                                      : 0.0;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          children: [
                            Text('$star stars',
                                style: const TextStyle(
                                    fontSize: 11, color: AppColors.textLight)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: pct,
                                  backgroundColor: AppColors.primarySurface,
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          AppColors.primary),
                                  minHeight: 8,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...dummyReviews.map((r) => _reviewCard(r)),
            const SizedBox(height: 8),
            Center(
              child: Text('See All ${book.reviewCount} Reviews',
                  style: const TextStyle(
                      fontSize: 13, color: AppColors.textLight)),
            ),
          ],
        );

      case 2: // Details
        return Column(
          children: [
            _detailRow(Icons.person_outline_rounded, 'Author', book.author),
            _detailRow(
                Icons.account_balance_outlined, 'Publisher', book.publisher),
            _detailRow(Icons.calendar_today_outlined, 'Released Date',
                book.releasedDate),
            _detailRow(Icons.bookmark_border_rounded, 'Genre', book.genre),
            _detailRow(Icons.barcode_reader, 'ISBN', book.isbn),
            _detailRow(Icons.language_rounded, 'Language', book.language),
            _detailRow(
                Icons.folder_outlined, 'File Size', '${book.fileSize} MB'),
            if (book.tags.isNotEmpty) ...[
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('TAGS',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textLight,
                            letterSpacing: 0.5)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: book.tags
                          .map((t) => Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.bgWhite,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: Text(t,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textMid)),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ],
          ],
        );

      default:
        return const SizedBox();
    }
  }

  Widget _iconBtn(IconData icon, VoidCallback onTap,
      {Color? color, Color? bgColor}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: bgColor ?? AppColors.bgWhite,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.06), blurRadius: 8)
          ],
        ),
        child: Icon(icon, size: 18, color: color ?? AppColors.textDark),
      ),
    );
  }

  Widget _pill(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 9, color: AppColors.textLight, letterSpacing: 0.3)),
          const SizedBox(height: 2),
          Text(value,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark)),
        ],
      ),
    );
  }

  Widget _tabBtn(String label, int index) {
    final active = _tab == index;
    return GestureDetector(
      onTap: () => setState(() => _tab = index),
      child: Column(
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                  color: active ? AppColors.primary : AppColors.textLight)),
          const SizedBox(height: 4),
          if (active)
            Container(
                height: 2,
                width: 40,
                decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(1))),
        ],
      ),
    );
  }

  Widget _reviewCard(Review r) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.primarySurface,
                  child: Text(r.avatar, style: const TextStyle(fontSize: 18))),
              const SizedBox(width: 10),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(r.name,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark)),
                  Row(
                      children: List.generate(
                          r.rating,
                          (_) => const Icon(Icons.star_rounded,
                              size: 12, color: AppColors.star))),
                ],
              )),
              Text(r.date,
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.textLight)),
            ],
          ),
          const SizedBox(height: 8),
          Text(r.text,
              style: const TextStyle(
                  fontSize: 13, color: AppColors.textMid, height: 1.5)),
        ],
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.border))),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primaryLighter),
          const SizedBox(width: 12),
          Text(label,
              style: const TextStyle(fontSize: 13, color: AppColors.textLight)),
          const Spacer(),
          Text(value,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark)),
        ],
      ),
    );
  }

  String _fmt(double p) => p.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
}
