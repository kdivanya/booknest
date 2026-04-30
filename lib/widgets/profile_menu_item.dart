import 'package:flutter/material.dart';
import '../constants/colors.dart';

// STATELESS WIDGET
class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? badge;
  final VoidCallback? onTap;
  final bool showDivider;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.label,
    this.badge,
    this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: showDivider
              ? const Border(bottom: BorderSide(color: AppColors.border))
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, size: 18, color: AppColors.primary),
            ),
            const SizedBox(width: 14),
            Expanded(child: Text(label,
                style: const TextStyle(fontSize: 14, color: AppColors.textDark))),
            if (badge != null)
              Container(
                width: 20, height: 20,
                decoration: const BoxDecoration(
                    color: AppColors.danger, shape: BoxShape.circle),
                child: Center(child: Text(badge!, style: const TextStyle(
                    color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold))),
              ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.textLight, size: 18),
          ],
        ),
      ),
    );
  }
}