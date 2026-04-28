import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/book.dart';

// STATELESS WIDGET — BookCard tidak berubah berdasarkan interaksi
class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback onTap;
  final double width;
  final double coverHeight;

  const BookCard({
    super.key,
    required this.book,
    required this.onTap,
    this.width = 120,
    this.coverHeight = 100,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border, width: 1),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover
            Container(
              height: coverHeight,
              decoration: BoxDecoration(
                color: AppColors.coverColors[book.coverColorIndex % AppColors.coverColors.length],
                borderRadius: const BorderRadius.vertical(top: Radius.circular(13)),
              ),
              child: Center(
                child: Text(
                  book.coverEmoji,
                  style: const TextStyle(fontSize: 36),
                ),
              ),
            ),
            // Info
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 11, color: AppColors.star),
                      const SizedBox(width: 2),
                      Text(
                        book.rating.toString(),
                        style: const TextStyle(fontSize: 10, color: AppColors.star),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Rp ${_formatPrice(book.price)}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w500,
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

  String _formatPrice(double price) {
    if (price >= 1000) {
      return '${(price / 1000).toStringAsFixed(0)}.000';
    }
    return price.toStringAsFixed(0);
  }
}

// STATELESS WIDGET — GenreBookCard versi kecil untuk list genre
class SmallBookCard extends StatelessWidget {
  final Book book;
  final VoidCallback onTap;

  const SmallBookCard({super.key, required this.book, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 70,
              decoration: BoxDecoration(
                color: AppColors.coverColors[book.coverColorIndex % AppColors.coverColors.length],
                borderRadius: const BorderRadius.vertical(top: Radius.circular(9)),
              ),
              child: Center(child: Text(book.coverEmoji, style: const TextStyle(fontSize: 26))),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Text(
                book.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 9, color: AppColors.textPrimary, height: 1.2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}