import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/cart_model.dart';
import 'checkout_page.dart';

// STATEFUL WIDGET — quantity update, remove item, total kalkulasi
class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final AppStore _store = AppStore();

  void _increment(String id) => setState(() => _store.incrementQty(id));
  void _decrement(String id) => setState(() => _store.decrementQty(id));
  void _remove(String id) => setState(() => _store.removeFromCart(id));

  @override
  Widget build(BuildContext context) {
    final items = _store.cartItems;
    final total = _store.cartTotal;

    return Scaffold(
      backgroundColor: AppColors.bgMain,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              color: AppColors.bgPurpleLight,
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              child: Row(
                children: [
                  if (Navigator.canPop(context))
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.primaryDark),
                    ),
                  if (Navigator.canPop(context)) const SizedBox(width: 10),
                  const Text(
                    'My Cart 🛒',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: AppColors.primaryDark),
                  ),
                  const Spacer(),
                  Text('${items.length} items', style: const TextStyle(fontSize: 13, color: AppColors.textMuted)),
                ],
              ),
            ),

            Expanded(
              child: items.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('🛒', style: TextStyle(fontSize: 56)),
                          SizedBox(height: 14),
                          Text('Your cart is empty', style: TextStyle(fontSize: 16, color: AppColors.textMuted, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: items.length,
                      itemBuilder: (_, i) => _cartItem(items[i]),
                    ),
            ),

            // Summary + Checkout
            if (items.isNotEmpty)
              Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: AppColors.border)),
                ),
                child: Column(
                  children: [
                    // Summary box
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.bgMain,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        children: [
                          _sumRow('Product', '${items.length} item${items.length > 1 ? 's' : ''}'),
                          const SizedBox(height: 4),
                          _sumRow('Subtotal', 'Rp ${_fmt(total)}'),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 6),
                            child: Divider(color: AppColors.border, height: 1),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('TOTAL', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                              Text('Rp ${_fmt(total)}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primaryDark)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => CheckoutPage(total: total)));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.primaryText,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: const Text('Checkout', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
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

  Widget _cartItem(CartItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cover
          Container(
            width: 60,
            height: 78,
            decoration: BoxDecoration(
              color: AppColors.coverColors[item.book.coverColorIndex % AppColors.coverColors.length],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(child: Text(item.book.coverEmoji, style: const TextStyle(fontSize: 28))),
          ),
          const SizedBox(width: 12),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.book.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary), maxLines: 2, overflow: TextOverflow.ellipsis),
                Text(item.book.author, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                const SizedBox(height: 6),
                Text('Rp ${_fmt(item.book.price)}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.primaryDark)),
                const SizedBox(height: 8),
                // Qty controls
                Row(
                  children: [
                    _qtyBtn(Icons.remove, () => _decrement(item.book.id)),
                    Container(
                      width: 32,
                      height: 28,
                      alignment: Alignment.center,
                      child: Text('${item.quantity}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                    ),
                    _qtyBtn(Icons.add, () => _increment(item.book.id)),
                  ],
                ),
              ],
            ),
          ),
          // Remove X
          GestureDetector(
            onTap: () => _remove(item.book.id),
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(Icons.close_rounded, size: 18, color: AppColors.textMuted),
            ),
          ),
        ],
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: AppColors.bgPurpleLight,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 14, color: AppColors.primaryDark),
      ),
    );
  }

  Widget _sumRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
        Text(value, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      ],
    );
  }

  String _fmt(double price) {
    final formatted = price.toStringAsFixed(0);
    if (formatted.length > 3) {
      final chars = formatted.split('').reversed.toList();
      final result = <String>[];
      for (int i = 0; i < chars.length; i++) {
        if (i > 0 && i % 3 == 0) result.add('.');
        result.add(chars[i]);
      }
      return result.reversed.join();
    }
    return formatted;
  }
}