import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/cart_model.dart';
import 'main_shell.dart';

// STATEFUL WIDGET — filter tab state, reads real orders from AppStore
class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});
  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final _store = AppStore();
  String _filter = 'All';
  final _filters = ['All', 'Shipping', 'Completed'];

  List<Order> get _filtered => _filter == 'All'
      ? _store.orders.value
      : _store.orders.value.where((o) => o.status == _filter).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const MainShell()),
                      (route) => false,
                    ),
                    child: Container(
                      width: 38, height: 38,
                      decoration: BoxDecoration(
                          color: AppColors.bgWhite,
                          borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.arrow_back_rounded,
                          size: 18, color: AppColors.textDark),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text('Order History',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark)),
                  const Spacer(),
                  const Icon(Icons.filter_list_rounded,
                      color: AppColors.textMid),
                ],
              ),
            ),

            // Filter tabs
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: _filters.map((f) {
                  final active = _filter == f;
                  return GestureDetector(
                    onTap: () => setState(() => _filter = f),
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 9),
                      decoration: BoxDecoration(
                        color: active ? AppColors.primary : AppColors.bgWhite,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color:
                                active ? AppColors.primary : AppColors.border),
                      ),
                      child: Text(f,
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color:
                                  active ? Colors.white : AppColors.textMid)),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 16),

            // Order list — listens to orders ValueNotifier
            Expanded(
              child: ValueListenableBuilder<List<Order>>(
                valueListenable: _store.orders,
                builder: (_, __, ___) {
                  final list = _filtered;
                  if (list.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.receipt_long_outlined,
                              size: 72, color: AppColors.primaryLighter),
                          const SizedBox(height: 16),
                          const Text('No orders yet',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textDark)),
                          const SizedBox(height: 8),
                          Text(
                            _filter == 'All'
                                ? 'Your order history will appear here.'
                                : 'No "$_filter" orders found.',
                            style: const TextStyle(
                                fontSize: 13, color: AppColors.textMid),
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: list.length,
                    itemBuilder: (_, i) => _orderCard(list[i]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _orderCard(Order order) {
    final isCompleted = order.status == 'Completed';
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: AppColors.primaryLighter.withValues(alpha: 0.12),
              blurRadius: 12,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order ID + status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(order.orderId,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark)),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isCompleted
                      ? const Color(0xFFE8F5E9)
                      : AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(order.status,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isCompleted
                            ? const Color(0xFF2E7D32)
                            : AppColors.primary)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Book list
          ...order.items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: 44, height: 44,
                        color: item.book.coverColor.withValues(alpha: 0.2),
                        child: Image.network(
                          item.book.coverUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.menu_book_rounded,
                            size: 20,
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
                          Text('x${item.quantity} · ${item.book.format}',
                              style: const TextStyle(
                                  fontSize: 11, color: AppColors.textLight)),
                        ],
                      ),
                    ),
                    Text('Rp ${_fmt(item.total)}',
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark)),
                  ],
                ),
              )),
          const Divider(color: AppColors.border, height: 20),
          // Footer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(order.formattedDate,
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.textLight)),
                  Text(order.paymentMethod,
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.textLight)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Total',
                      style:
                          TextStyle(fontSize: 11, color: AppColors.textLight)),
                  Text('Rp ${_fmt(order.total)}',
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _fmt(double p) => p
      .toStringAsFixed(0)
      .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
}
