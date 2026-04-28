import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/cart_model.dart';
import 'order_placed_screen.dart';

// STATEFUL WIDGET — payment method selection state
class CheckoutPage extends StatefulWidget {
  final double total;
  const CheckoutPage({super.key, required this.total});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String _selectedPayment = 'QRIS';
  final AppStore _store = AppStore();

  final Map<String, IconData> _paymentMethods = {
    'QRIS': Icons.qr_code_2_rounded,
    'Debit Card': Icons.credit_card_rounded,
    'Bank Transfer': Icons.account_balance_rounded,
    'COD': Icons.local_shipping_rounded,
  };

  void _placeOrder() {
    _store.cartItems.clear();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const OrderPlacedScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.primaryDark),
                  ),
                  const SizedBox(width: 10),
                  const Text('Checkout', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: AppColors.primaryDark)),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Address ──
                    _sectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.location_on_rounded, size: 18, color: AppColors.primaryDark),
                              const SizedBox(width: 8),
                              const Expanded(
                                child: Text('Address', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.primaryDark)),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: const Text('edit', style: TextStyle(fontSize: 12, color: AppColors.primary)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Jl. Melati No. 12, Kuta\nBadung, Bali 80361\nIndonesia',
                            style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.5),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ── Payment Methods ──
                    _sectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Payment Methods', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.primaryDark)),
                              TextButton(
                                onPressed: () {},
                                child: const Text('view more >', style: TextStyle(fontSize: 12, color: AppColors.primary)),
                              ),
                            ],
                          ),
                          ..._paymentMethods.entries.map((e) => _paymentItem(e.key, e.value)),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ── Voucher ──
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.bgCard,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.borderMid, style: BorderStyle.solid),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.confirmation_number_outlined, color: AppColors.primary, size: 20),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text('See All Vouchers', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                            ),
                            Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ── Summary ──
                    _sectionCard(
                      child: Column(
                        children: [
                          _sumRow('Product', '${_store.cartCount} items'),
                          const SizedBox(height: 4),
                          _sumRow('Subtotal', 'Rp ${_fmt(widget.total)}'),
                          _sumRow('Shipping', 'Rp 0'),
                          const Padding(padding: EdgeInsets.symmetric(vertical: 6), child: Divider(color: AppColors.border, height: 1)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('TOTAL', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                              Text('Rp ${_fmt(widget.total)}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primaryDark)),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Place Order button
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
                  onPressed: _placeOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.primaryText,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Place Order', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _paymentItem(String name, IconData icon) {
    final bool isSelected = _selectedPayment == name;
    return GestureDetector(
      onTap: () => setState(() => _selectedPayment = name),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Icon(icon, size: 20, color: isSelected ? AppColors.primaryDark : AppColors.textMuted),
            const SizedBox(width: 10),
            Expanded(child: Text(name, style: TextStyle(fontSize: 13, color: isSelected ? AppColors.textPrimary : AppColors.textSecondary))),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: isSelected ? AppColors.primary : AppColors.borderMid, width: 1.5),
              ),
              child: isSelected
                  ? Center(child: Container(width: 10, height: 10, decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primary)))
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }

  Widget _sumRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
          Text(value, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
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