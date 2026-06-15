import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/cart_model.dart';
import 'order_success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _store = AppStore();
  final _addressCtrl = TextEditingController(text: 'Jl. Telekomunikasi No. 1, Bandung');
  int _selectedPayment = 0;
  bool _processing = false;

  final _paymentMethods = [
    {'name': 'GoPay', 'icon': Icons.account_balance_wallet_rounded, 'detail': 'Balance: Rp 250.000'},
    {'name': 'Transfer Bank BCA', 'icon': Icons.account_balance_rounded, 'detail': 'BCA Virtual Account'},
    {'name': 'OVO', 'icon': Icons.account_balance_wallet_outlined, 'detail': 'Balance: Rp 80.000'},
    {'name': 'DANA', 'icon': Icons.wallet_rounded, 'detail': 'Balance: Rp 130.000'},
    {'name': 'Credit Card', 'icon': Icons.credit_card_rounded, 'detail': 'Visa / Mastercard'},
  ];

  String _fmt(double p) => p
      .toStringAsFixed(0)
      .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');

  @override
  void dispose() {
    _addressCtrl.dispose();
    super.dispose();
  }

  void _placeOrder() async {
    if (_addressCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a delivery address.'),
          backgroundColor: AppColors.danger,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    setState(() => _processing = true);
    await Future.delayed(const Duration(milliseconds: 800));

    _store.placeOrder(
      address: _addressCtrl.text.trim(),
      paymentMethod: _paymentMethods[_selectedPayment]['name'] as String,
    );

    if (!mounted) return;
    setState(() => _processing = false);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const OrderSuccessScreen()),
      (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    final selected = _store.cart.where((c) => c.isSelected).toList();
    final total = _store.selectedTotal;
    final shipping = 15000.0;
    final grandTotal = total + shipping;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 38, height: 38,
                      decoration: BoxDecoration(
                        color: AppColors.bgWhite,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.arrow_back_rounded,
                          size: 18, color: AppColors.textDark),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text('Checkout',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark)),
                ],
              ),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Order Summary ──
                    _sectionTitle('Order Summary (${selected.length} item${selected.length > 1 ? 's' : ''})'),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.bgWhite,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: selected.map((item) => Padding(
                          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  width: 52, height: 52,
                                  color: item.book.coverColor.withValues(alpha: 0.2),
                                  child: Image.network(
                                    item.book.coverUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Icon(
                                      Icons.menu_book_rounded,
                                      color: item.book.coverColor,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.book.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textDark)),
                                    Text('x${item.quantity}',
                                        style: const TextStyle(
                                            fontSize: 12, color: AppColors.textMid)),
                                  ],
                                ),
                              ),
                              Text('Rp ${_fmt(item.total)}',
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary)),
                            ],
                          ),
                        )).toList(),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Delivery Address ──
                    _sectionTitle('Delivery Address'),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.bgWhite,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.location_on_rounded,
                                  color: AppColors.primary, size: 18),
                              const SizedBox(width: 8),
                              Text(_store.currentUser,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textDark)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _addressCtrl,
                            maxLines: 2,
                            style: const TextStyle(
                                fontSize: 13, color: AppColors.textDark),
                            decoration: InputDecoration(
                              hintText: 'Enter full delivery address...',
                              hintStyle:
                                  const TextStyle(color: AppColors.textHint),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    const BorderSide(color: AppColors.border),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    const BorderSide(color: AppColors.primary),
                              ),
                              filled: true,
                              fillColor: AppColors.bg,
                              contentPadding: const EdgeInsets.all(12),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Payment Method ──
                    _sectionTitle('Payment Method'),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.bgWhite,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: List.generate(_paymentMethods.length, (i) {
                          final method = _paymentMethods[i];
                          final selected = i == _selectedPayment;
                          return GestureDetector(
                            onTap: () =>
                                setState(() => _selectedPayment = i),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: i < _paymentMethods.length - 1
                                      ? const BorderSide(color: AppColors.border)
                                      : BorderSide.none,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40, height: 40,
                                    decoration: BoxDecoration(
                                      color: selected
                                          ? AppColors.primarySurface
                                          : AppColors.bg,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                        method['icon'] as IconData,
                                        color: selected
                                            ? AppColors.primary
                                            : AppColors.textLight,
                                        size: 20),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(method['name'] as String,
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: selected
                                                    ? AppColors.primary
                                                    : AppColors.textDark)),
                                        Text(method['detail'] as String,
                                            style: const TextStyle(
                                                fontSize: 11,
                                                color: AppColors.textLight)),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 20, height: 20,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: selected
                                            ? AppColors.primary
                                            : AppColors.border,
                                        width: 2,
                                      ),
                                    ),
                                    child: selected
                                        ? Center(
                                            child: Container(
                                              width: 10, height: 10,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                          )
                                        : null,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Price Breakdown ──
                    _sectionTitle('Price Details'),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.bgWhite,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          _priceRow('Subtotal', 'Rp ${_fmt(total)}'),
                          const SizedBox(height: 8),
                          _priceRow('Shipping', 'Rp ${_fmt(shipping)}'),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Divider(color: AppColors.border, height: 1),
                          ),
                          _priceRow('Total', 'Rp ${_fmt(grandTotal)}',
                              bold: true, color: AppColors.primary),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // ── Place Order Button ──
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              decoration: const BoxDecoration(
                color: AppColors.bgWhite,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _processing ? null : _placeOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26)),
                  ),
                  child: _processing
                      ? const SizedBox(
                          width: 22, height: 22,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Place Order',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600)),
                            const SizedBox(width: 8),
                            Text('· Rp ${_fmt(grandTotal)}',
                                style: const TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w400)),
                          ],
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) => Text(text,
      style: const TextStyle(
          fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textDark));

  Widget _priceRow(String label, String value,
      {bool bold = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 13,
                color: bold ? AppColors.textDark : AppColors.textMid,
                fontWeight: bold ? FontWeight.w600 : FontWeight.normal)),
        Text(value,
            style: TextStyle(
                fontSize: 13,
                fontWeight: bold ? FontWeight.bold : FontWeight.w500,
                color: color ?? AppColors.textDark)),
      ],
    );
  }
}
