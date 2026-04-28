import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/book.dart';
import '../models/cart_model.dart';
import 'cart_page.dart';

// STATEFUL WIDGET — menyimpan state wishlist toggle & scroll
class DetailBookPage extends StatefulWidget {
  final Book book;
  const DetailBookPage({super.key, required this.book});

  @override
  State<DetailBookPage> createState() => _DetailBookPageState();
}

class _DetailBookPageState extends State<DetailBookPage> {
  final AppStore _store = AppStore();
  bool _inWishlist = false;

  static const List<Map<String, String>> _dummyComments = [
    {'user': 'Rina', 'stars': '5', 'text': 'Buku yang sangat menyentuh hati! Wajib dibaca.'},
    {'user': 'Dani', 'stars': '4', 'text': 'Plot yang luar biasa dan unik, tidak terduga.'},
    {'user': 'Ayu', 'stars': '5', 'text': 'Habis baca nangis di kamar, 10/10 recommended!'},
  ];

  @override
  void initState() {
    super.initState();
    _inWishlist = _store.isInWishlist(widget.book.id);
  }

  void _toggleWishlist() {
    setState(() {
      if (_inWishlist) {
        _store.removeFromWishlist(widget.book.id);
        _inWishlist = false;
        _showSnack('Removed from wishlist');
      } else {
        _store.addToWishlist(widget.book);
        _inWishlist = true;
        _showSnack('Added to wishlist! ❤️');
      }
    });
  }

  void _addToCartAndGo() {
    _store.addToCart(widget.book);
    Navigator.push(context, MaterialPageRoute(builder: (_) => const CartPage()));
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: const Duration(seconds: 1),
        backgroundColor: AppColors.primaryDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final book = widget.book;
    return Scaffold(
      backgroundColor: AppColors.bgMain,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Cover ──
                    Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 240,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.coverColors[book.coverColorIndex % AppColors.coverColors.length],
                                AppColors.bgPurpleLight,
                              ],
                            ),
                          ),
                          child: Center(
                            child: Text(book.coverEmoji, style: const TextStyle(fontSize: 80)),
                          ),
                        ),
                        // Back button
                        Positioned(
                          top: 12,
                          left: 12,
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.85),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: AppColors.primaryDark),
                            ),
                          ),
                        ),
                        // W — Wishlist button
                        Positioned(
                          top: 12,
                          right: 12,
                          child: GestureDetector(
                            onTap: _toggleWishlist,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: _inWishlist ? AppColors.primary : Colors.white.withValues(alpha: 0.85),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  'W',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: _inWishlist ? Colors.white : AppColors.primaryDark,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // ── Book Info ──
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Stars
                          Row(
                            children: List.generate(5, (i) {
                              return Icon(
                                i < book.rating.floor() ? Icons.star_rounded : Icons.star_border_rounded,
                                color: AppColors.star,
                                size: 20,
                              );
                            }),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            book.title,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryDeep,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'by ${book.author}',
                            style: const TextStyle(fontSize: 14, color: AppColors.textMuted),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                'Rp ${_fmt(book.price)}',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Format badges
                              if (book.isEbook)
                                _badge('E-Book', AppColors.bgBlue, const Color(0xFF2D5C99)),
                              const SizedBox(width: 6),
                              if (book.isPhysical)
                                _badge('Fisik', AppColors.bgGreen, AppColors.success),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${book.reviewCount} reviews · ★ ${book.rating}',
                            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                          ),

                          // ── Sinopsis ──
                          const SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.bgPurpleLight,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'SINOPSIS',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryDark,
                                    letterSpacing: 1,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  book.synopsis,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textPrimary,
                                    height: 1.6,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // ── Comments ──
                          const SizedBox(height: 20),
                          const Text(
                            'Comments',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primaryDark,
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Comment input
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 12),
                                const CircleAvatar(
                                  radius: 14,
                                  backgroundColor: AppColors.bgPurpleLight,
                                  child: Icon(Icons.person_rounded, size: 16, color: AppColors.primaryDark),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    onChanged: (v) {},
                                    style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
                                    decoration: const InputDecoration(
                                      hintText: 'Write a comment...',
                                      hintStyle: TextStyle(fontSize: 13, color: AppColors.textHint),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.send_rounded, color: AppColors.primary, size: 18),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Comment list
                          ..._dummyComments.map((c) => _commentItem(c)),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Buy Now button ──
            Container(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _addToCartAndGo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.primaryText,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text(
                    'Buy Now',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _badge(String label, Color bg, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label, style: TextStyle(fontSize: 11, color: textColor, fontWeight: FontWeight.w500)),
    );
  }

  Widget _commentItem(Map<String, String> c) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 14,
            backgroundColor: AppColors.bgPurpleLight,
            child: Icon(Icons.person_rounded, size: 14, color: AppColors.primaryDark),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(c['user']!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                    const SizedBox(width: 6),
                    Row(
                      children: List.generate(int.parse(c['stars']!), (_) =>
                        const Icon(Icons.star_rounded, size: 10, color: AppColors.star)),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(c['text']!, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(double price) => '${(price / 1000).toStringAsFixed(0)}.000';
}