import 'auth_gate_screen.dart';
import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/cart_model.dart';
import 'order_history_screen.dart';

// STATELESS WIDGET
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = AppStore();
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ── Profile header ──
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                decoration: const BoxDecoration(
                  color: AppColors.primarySurface,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.arrow_back_rounded, color: AppColors.textDark),
                        ),
                        const Spacer(),
                        const Icon(Icons.settings_outlined, color: AppColors.textMid),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Stack(
                      children: [
                        Container(
                          width: 80, height: 80,
                          decoration: const BoxDecoration(
                            color: AppColors.bgWhite,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(Icons.person_rounded, size: 44, color: AppColors.primaryLight),
                          ),
                        ),
                        Positioned(
                          bottom: 0, right: 0,
                          child: Container(
                            width: 24, height: 24,
                            decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                            child: const Icon(Icons.camera_alt_rounded, size: 13, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(store.currentUser,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                    const SizedBox(height: 4),
                    Text(store.currentEmail,
                        style: const TextStyle(fontSize: 13, color: AppColors.textMid)),
                    const SizedBox(height: 16),
                    // Stats
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.bgWhite,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _stat('24', 'READ'),
                          Container(width: 1, height: 30, color: AppColors.border),
                          _stat('12', 'WISHLIST'),
                          Container(width: 1, height: 30, color: AppColors.border),
                          _stat('8', 'REVIEWS'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── Account section ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Account',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                    const SizedBox(height: 12),
                    _menuGroup([
                      _menuItem(context, Icons.manage_accounts_outlined, 'Manage Profile', null),
                      _menuItem(context, Icons.location_on_outlined, 'Address', null),
                      _menuItem(context, Icons.shield_outlined, 'Password & Security', null),
                      _menuItem(context, Icons.notifications_outlined, 'Notifications', '2'),
                      _menuItem(context, Icons.history_rounded, 'History', null,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OrderHistoryScreen()))),
                    ]),
                    const SizedBox(height: 20),
                    const Text('Support',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                    const SizedBox(height: 12),
                    _menuGroup([
                      _menuItem(context, Icons.info_outline_rounded, 'Help Center', null),
                    ]),
                    const SizedBox(height: 20),
                    // Log Out
                    GestureDetector(
                      onTap: () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const AuthGateScreen()),
                        (_) => false),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: AppColors.bgWhite,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.logout_rounded, color: AppColors.danger, size: 18),
                            SizedBox(width: 8),
                            Text('Log Out', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.danger)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.edit_rounded, size: 14, color: AppColors.primaryLighter),
                          const SizedBox(width: 6),
                          Text('BookNest v2.4.0',
                              style: TextStyle(fontSize: 12, color: AppColors.primaryLighter.withValues(alpha: 0.7))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stat(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textLight, letterSpacing: 0.3)),
      ],
    );
  }

  Widget _menuGroup(List<Widget> items) {
    return Container(
      decoration: BoxDecoration(color: AppColors.bgWhite, borderRadius: BorderRadius.circular(16)),
      child: Column(children: items),
    );
  }

  Widget _menuItem(BuildContext context, IconData icon, String label, String? badge, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.border))),
        child: Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(color: AppColors.primarySurface, borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, size: 18, color: AppColors.primary),
            ),
            const SizedBox(width: 14),
            Expanded(child: Text(label, style: const TextStyle(fontSize: 14, color: AppColors.textDark))),
            if (badge != null)
              Container(
                width: 20, height: 20,
                decoration: const BoxDecoration(color: AppColors.danger, shape: BoxShape.circle),
                child: Center(child: Text(badge, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold))),
              ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textLight, size: 18),
          ],
        ),
      ),
    );
  }
}
