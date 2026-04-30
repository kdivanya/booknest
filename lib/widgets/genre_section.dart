import 'package:flutter/material.dart';
import '../constants/colors.dart';

// STATELESS WIDGET
class GenreSection extends StatelessWidget {
  final String genre;
  final VoidCallback? onTap;

  const GenreSection({super.key, required this.genre, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.bgWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.category_outlined,
                  size: 18, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Text(genre, style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textDark)),
            const Spacer(),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.textLight, size: 18),
          ],
        ),
      ),
    );
  }
}