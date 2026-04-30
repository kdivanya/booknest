import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/cart_model.dart';

// STATELESS WIDGET
class BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const BottomNav({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cartCount = AppStore().cartCount;
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bgWhite,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _item(Icons.home_rounded, 'Home', 0),
              _item(Icons.favorite_border_rounded, 'Wishlist', 1),
              _cartItem(cartCount),
              _item(Icons.receipt_long_rounded, 'Orders', 3),
              _item(Icons.person_outline_rounded, 'Profile', 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _item(IconData icon, String label, int index) {
    final active = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(width: 60,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, size: 24, color: active ? AppColors.primary : AppColors.textLight),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 10,
              color: active ? AppColors.primary : AppColors.textLight,
              fontWeight: active ? FontWeight.w600 : FontWeight.w400)),
        ]),
      ),
    );
  }

  Widget _cartItem(int count) {
    final active = currentIndex == 2;
    return GestureDetector(
      onTap: () => onTap(2),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(width: 60,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Stack(clipBehavior: Clip.none, children: [
            Icon(Icons.shopping_cart_outlined, size: 24,
                color: active ? AppColors.primary : AppColors.textLight),
            if (count > 0)
              Positioned(top: -4, right: -6,
                child: Container(width: 16, height: 16,
                  decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                  child: Center(child: Text('$count',
                      style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold))),
                )),
          ]),
          const SizedBox(height: 2),
          Text('Cart', style: TextStyle(fontSize: 10,
              color: active ? AppColors.primary : AppColors.textLight,
              fontWeight: active ? FontWeight.w600 : FontWeight.w400)),
        ]),
      ),
    );
  }
}
