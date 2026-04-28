import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/cart_model.dart';
import 'cart_page.dart';
import 'detail_book_page.dart';

// STATEFUL WIDGET — mode selection, checkbox toggle, popup menu
class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  final AppStore _store = AppStore();
  bool _selectMode = false;
  bool _selectAll = false;

  List<WishlistItem> get items => _store.wishlistItems;

  void _toggleSelectMode() {
    setState(() {
      _selectMode = !_selectMode;
      if (!_selectMode) {
        for (var item in items) {
          item.isSelected = false;
        }
        _selectAll = false;
      }
    });
  }

  void _toggleItem(int index) {
    setState(() {
      items[index].isSelected = !items[index].isSelected;
      _selectAll = items.every((i) => i.isSelected);
    });
  }

  void _toggleAll() {
    setState(() {
      _selectAll = !_selectAll;
      for (var item in items) {
        item.isSelected = _selectAll;
      }
    });
  }

  void _deleteSelected() {
    final toDelete = items.where((i) => i.isSelected).map((i) => i.book.id).toList();
    for (var id in toDelete) {
      _store.removeFromWishlist(id);
    }
    setState(() {
      _selectMode = false;
      _selectAll = false;
    });
  }

  void _buySelected() {
    final selected = items.where((i) => i.isSelected).toList();
    for (var item in selected) {
      _store.addToCart(item.book);
    }
    setState(() {
      _selectMode = false;
      _selectAll = false;
      for (var item in items) {
        item.isSelected = false;
      }
    });
    Navigator.push(context, MaterialPageRoute(builder: (_) => const CartPage()));
  }

  void _showItemOptions(int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)),
            ),
            ListTile(
              leading: const Icon(Icons.check_circle_outline_rounded, color: AppColors.primaryDark),
              title: const Text('Pilih', style: TextStyle(color: AppColors.textPrimary)),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectMode = true;
                  items[index].isSelected = true;
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline_rounded, color: AppColors.danger),
              title: const Text('Hapus', style: TextStyle(color: AppColors.danger)),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _store.removeFromWishlist(items[index].book.id);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgMain,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──
            Container(
              color: AppColors.bgPurpleLight,
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              child: Row(
                children: [
                  if (_selectMode)
                    GestureDetector(
                      onTap: _toggleSelectMode,
                      child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.primaryDark),
                    ),
                  if (_selectMode) const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'My Wishlist ❤️',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: AppColors.primaryDark),
                    ),
                  ),
                  if (!_selectMode)
                    TextButton(
                      onPressed: items.isEmpty ? null : _toggleSelectMode,
                      child: const Text('Select', style: TextStyle(color: AppColors.primaryDark, fontSize: 13)),
                    ),
                ],
              ),
            ),

            // ── Content ──
            Expanded(
              child: items.isEmpty
                  ? _buildEmpty()
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: items.length,
                      itemBuilder: (_, i) => _wishItem(i),
                    ),
            ),

            // ── Footer (select mode) ──
            if (_selectMode)
              Container(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: AppColors.border)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: _toggleAll,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: _selectAll ? AppColors.primary : Colors.transparent,
                              border: Border.all(color: AppColors.borderStrong, width: 1.5),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: _selectAll
                                ? const Icon(Icons.check, size: 14, color: Colors.white)
                                : null,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('Semua', style: TextStyle(fontSize: 13, color: AppColors.textPrimary)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: items.any((i) => i.isSelected) ? _buySelected : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.primaryText,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('Buy Now', style: TextStyle(fontWeight: FontWeight.w500)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: items.any((i) => i.isSelected) ? _deleteSelected : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.dangerBg,
                              foregroundColor: AppColors.danger,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('Delete', style: TextStyle(fontWeight: FontWeight.w500)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _wishItem(int index) {
    final item = items[index];
    return GestureDetector(
      onTap: () {
        if (_selectMode) {
          _toggleItem(index);
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => DetailBookPage(book: item.book)),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: item.isSelected ? AppColors.primary : AppColors.border,
            width: item.isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            // Checkbox (select mode only)
            if (_selectMode) ...[
              GestureDetector(
                onTap: () => _toggleItem(index),
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: item.isSelected ? AppColors.primary : Colors.transparent,
                    border: Border.all(color: AppColors.borderStrong, width: 1.5),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: item.isSelected
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(width: 10),
            ],
            // Cover
            Container(
              width: 52,
              height: 66,
              decoration: BoxDecoration(
                color: AppColors.coverColors[item.book.coverColorIndex % AppColors.coverColors.length],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(child: Text(item.book.coverEmoji, style: const TextStyle(fontSize: 24))),
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.book.title,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                  Text(item.book.author,
                      style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 12, color: AppColors.star),
                      Text(' ${item.book.rating}',
                          style: const TextStyle(fontSize: 11, color: AppColors.star)),
                      const SizedBox(width: 8),
                      Text('Rp ${_fmt(item.book.price)}',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.primaryDark)),
                    ],
                  ),
                ],
              ),
            ),
            // Three dots
            if (!_selectMode)
              GestureDetector(
                onTap: () => _showItemOptions(index),
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(Icons.more_vert_rounded, color: AppColors.textMuted, size: 20),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('❤️', style: TextStyle(fontSize: 56)),
          SizedBox(height: 14),
          Text('Your wishlist is empty',
              style: TextStyle(fontSize: 16, color: AppColors.textMuted, fontWeight: FontWeight.w500)),
          SizedBox(height: 6),
          Text('Tap W on any book to add it here',
              style: TextStyle(fontSize: 12, color: AppColors.textHint)),
        ],
      ),
    );
  }

  String _fmt(double price) => '${(price / 1000).toStringAsFixed(0)}.000';
}